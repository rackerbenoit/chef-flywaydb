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

def usr
  new_resource.user.nil? ? 'flyway' : new_resource.user
end

def grp
  if new_resource.group.nil?
    platform?('windows') ? 'Administrators' : 'flyway'
  else
    new_resource.group
  end
end

def create_usr_grp
  user usr do # ~FC021
    comment 'Flyway System User'
    home install_path
    shell '/sbin/nologin'
    password new_resource.password
    system true
    action %i(create lock)
    only_if { new_resource.user.nil? }
  end

  group grp do # ~FC021
    append true
    members usr
    action :create
    only_if { new_resource.group.nil? || (platform?('windows') && new_resource.group == 'Administrators') }
  end
end

def install_flyway
  url = node['flywaydb']['url']
  cache = "#{Chef::Config[:file_cache_path]}#{url.slice(url.rindex('/'), url.size)}"

  create_usr_grp

  directory new_resource.install_dir do
    owner usr
    group grp
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
      command "tar -xvzf #{cache}"
      cwd new_resource.install_dir
      user usr
      group grp
      action :nothing
    end
  end

  target_dir = "#{new_resource.install_dir}/flyway"

  link target_dir do
    to install_path
    user usr
    group grp
  end

  execute "chmod +x #{target_dir}/flyway" do
    not_if { platform?('windows') }
  end

  mariadb_driver
  mysql_driver
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength

def mysql_driver
  return unless new_resource.mysql_driver

  download_driver('mysql-connector-java', node['flywaydb']['mysql']['url'], node['flywaydb']['mysql']['sha256'])
end

def mariadb_driver
  return unless node['flywaydb']['mariadb']['version'] && !new_resource.mysql_driver

  download_driver('mariadb-java-client', node['flywaydb']['mariadb']['url'], node['flywaydb']['mariadb']['sha256'])
end

def download_driver(name, url, sha256)
  driver_path = "#{install_path}/drivers#{url.slice(url.rindex('/'), url.size)}"

  ruby_block "remove #{name}" do
    block do
      require 'fileutils'
      ::FileUtils.rm_r(::Dir.glob("#{install_path}/drivers/#{name}-*.jar"))
    end
    not_if { ::File.exist?(driver_path) }
  end

  remote_file driver_path do
    source url
    checksum sha256
    user usr
    group grp
  end
end

def validate_attributes
  raise "Flywaydb resource name cannot be 'flyway'!" \
    if new_resource.name.casecmp('flyway') == 0 && !new_resource.flyway_conf.nil?

  raise('Flywaydb requires at least one following attributes to be defined: flyway_conf, alt_conf, or parameters!') \
    if new_resource.flyway_conf.nil? && new_resource.alt_conf.nil? && new_resource.parameters.empty?
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
  new_resource.parameters.each do |key, value|
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
    owner usr
    group grp
  end
end

def process_conf(resource_obj, command, conf_name, run = false)
  conf_path = "#{install_path}/conf/#{conf_name}.conf"
  case resource_obj
  when Array
    resource_obj.each_with_index do |obj, i|
      process_conf(obj, command, "#{conf_name}_#{i + 1}", run)
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
