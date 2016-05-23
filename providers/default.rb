use_inline_resources

def whyrun_supported?
  true
end

def flyway_version # url can override version specified in attributes
  /flyway-commandline-(.*\d)-/.match(node['flywaydb']['url'])[1]
end

def install_path
  "#{new_resource.install_dir}/flyway-#{flyway_version}"
end

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
def install_flyway
  url = node['flywaydb']['url']
  cache = "#{Chef::Config[:file_cache_path]}#{url.slice(url.rindex('/'), url.size)}"

  user new_resource.user do
    comment 'Flyway System User'
    home install_path
    shell '/sbin/nologin'
    password new_resource.password
    system true
    action [:create, :lock]
  end

  group new_resource.group do
    append true
    members new_resource.user
    action :create
  end

  directory install_path do
    owner new_resource.user
    group new_resource.group
    mode '0755'
    recursive true
  end

  remote_file cache do
    source url
    checksum node['flywaydb']['sha256']
    notifies :run, 'batch[unzip flyway (powershell 3 or higher required)]', :immediately if platform?('windows')
    notifies :run, 'execute[extract flyway]', :immediately unless platform?('windows')
  end

  if platform?('windows')
    batch 'unzip flyway (powershell 3 or higher required)' do
      code "powershell.exe -nologo -noprofile -command \"& { Add-Type -A 'System.IO.Compression.FileSystem';" \
      " [IO.Compression.ZipFile]::ExtractToDirectory('#{cache}', '#{new_resource.install_dir}'); }\""
      action :nothing
    end
  else
    execute 'extract flyway' do
      command "tar -xvzf #{cache} --strip 1"
      cwd install_path
      user new_resource.user
      group new_resource.group
      action :nothing
    end
  end

  target_dir = "#{new_resource.install_dir}/flyway"

  ruby_block "mv legacy #{target_dir} dir" do
    block do
      ::File.rename(target_dir, "#{new_resource.install_dir}/flyway_legacy")
    end
    only_if { ::File.exist?(target_dir) && !::File.symlink?(target_dir) && !platform?('windows') }
  end

  link target_dir do
    to install_path
    user new_resource.user
    group new_resource.group
  end

  mysql_driver
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
def mysql_driver
  return unless new_resource.mysql_driver

  url = node['flywaydb']['mysql']['url']
  cache = "#{Chef::Config[:file_cache_path]}#{url.slice(url.rindex('/'), url.size)}"

  remote_file cache do
    source url
    checksum node['flywaydb']['mysql']['sha256']
  end

  mysql_driver_extract_jar = "#{install_path}/drivers/mysql-connector-java-#{node['flywaydb']['mysql']['version']}" \
    "/mysql-connector-java-#{node['flywaydb']['mysql']['version']}-bin.jar"

  if platform?('windows')
    batch 'unzip mysql driver (powershell 3 or higher required)' do
      code "powershell.exe -nologo -noprofile -command \"& { Add-Type -A 'System.IO.Compression.FileSystem';" \
        " [IO.Compression.ZipFile]::ExtractToDirectory('#{cache}', '#{install_path}/drivers'); }\""
      not_if { ::File.exist?(mysql_driver_extract_jar) }
    end
  else
    execute 'extract mysql driver' do
      command "tar -xvzf #{cache}"
      cwd "#{install_path}/drivers"
      user new_resource.user
      group new_resource.group
      not_if { ::File.exist?(mysql_driver_extract_jar) }
    end
  end

  mysql_driver_jar = "#{install_path}/drivers/mysql-connector-java-bin.jar"

  ruby_block "rm legacy #{mysql_driver_jar}" do
    block do
      require 'fileutils'
      ::FileUtils.remove_file(mysql_driver_jar, true)
    end
    only_if { ::File.exist?(mysql_driver_jar) && !::File.symlink?(mysql_driver_jar) && !platform?('windows') }
  end

  link mysql_driver_jar do
    to mysql_driver_extract_jar
    user new_resource.user
    group new_resource.group
  end
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength

def validate_attributes
  if new_resource.name.casecmp('flyway').zero? && !new_resource.flyway_conf.nil?
    raise "Flywaydb resource name cannot be 'flyway'!"
  end

  if new_resource.flyway_conf.nil? && new_resource.alt_conf.nil? && new_resource.params.empty?
    raise('Flywaydb requires at least one following attributes to be defined: flyway_conf, alt_conf, or params!')
  end
end

def exec_path
  if platform?('windows')
    "#{install_path}/flyway.cmd"
  else
    "#{install_path}/flyway"
  end
end

def build_command(command, conf_path)
  cmd = [exec_path]
  new_resource.params.each do |key, value|
    cmd << (platform?('windows') ? "-#{key}=\"#{value}\"" : "-#{key}='#{value}'")
  end
  cmd << (platform?('windows') ? "-configFile=\"#{conf_path}\"" : "-configFile='#{conf_path}'")
  cmd << '-X' if new_resource.debug
  cmd << command
  cmd.join(' ')
end

def write_conf(conf_path, hash)
  template conf_path do
    source 'flyway.conf.erb'
    sensitive new_resource.sensitive
    variables(conf: hash)
    cookbook 'flywaydb'
    owner new_resource.user
    group new_resource.group
  end
end

def process_conf(resource_obj, command, conf_name, run = false)
  conf_path = "#{install_path}/conf/#{conf_name}.conf"
  case resource_obj
  when Array
    resource_obj.each_with_index do |obj, i|
      process_conf(obj, command, "#{conf_name}_#{i + 1}")
    end
  when Hash
    write_conf(conf_path, resource_obj)
    exec_flyway(command, conf_path) if run
  when String
    remote_file conf_path do
      source "file://#{resource_obj.gsub('file://', '')}"
    end

    exec_flyway(command, conf_path) if run
  else
    write_conf(conf_path, {})
  end
end

def exec_flyway(command, conf_path)
  cmd = build_command(command, conf_path)

  # if sensitive then suppress cmd but not stdout or stderr
  ruby_block "flyway #{command} #{conf_path}" do
    block do
      puts ''
      puts cmd unless new_resource.sensitive
      exec = Mixlib::ShellOut.new(cmd, timeout: new_resource.timeout)
      exec.run_command
      puts exec.stdout
      raise exec.stderr if exec.error?
    end
  end
end

def flyway(command)
  validate_attributes

  install_flyway

  run = new_resource.alt_conf.nil? ? true : false
  process_conf(new_resource.flyway_conf, command, 'flyway', run)

  name = new_resource.name.tr(' ', '_')
  process_conf(new_resource.alt_conf, command, name, true) unless new_resource.alt_conf.nil?
end

action :migrate do
  converge_by('migrate') do
    flyway('migrate')
  end
end

action :clean do
  converge_by('clean') do
    flyway('clean')
  end
end

action :info do
  converge_by('info') do
    flyway('info')
  end
end

action :validate do
  converge_by('validate') do
    flyway('validate')
  end
end

action :baseline do
  converge_by('baseline') do
    flyway('baseline')
  end
end

action :repair do
  converge_by('repair') do
    flyway('repair')
  end
end

action :install do
  converge_by('install') do
    install_flyway
  end
end
