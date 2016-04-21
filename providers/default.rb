use_inline_resources

def whyrun_supported?
  true
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

  directory new_resource.install_dir do
    owner new_resource.user
    group new_resource.group
    mode '0755'
  end

  remote_file 'download flywaydb' do
    path cache
    source node['flywaydb']['url']
    checksum node['flywaydb']['sha256']
    notifies :run, 'batch[unzip flyway (powershell 3 or higher required)]', :immediately if platform?('windows')
    notifies :run, 'execute[extract flyway]', :immediately unless platform?('windows')
  end

  if platform?('windows')
    batch 'unzip flyway (powershell 3 or higher required)' do
      code "powershell.exe -nologo -noprofile -command \"& { Add-Type -A 'System.IO.Compression.FileSystem';"\
      " [IO.Compression.ZipFile]::ExtractToDirectory('#{cache}', '#{new_resource.install_dir}'); }\""
      action :nothing
    end
  else
    execute 'extract flyway' do
      command "tar -xvzf #{cache} --strip 1 && chown -R #{new_resource.user}:#{new_resource.group} ."
      cwd new_resource.install_dir
      action :nothing
    end
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

def install_path
  if platform?('windows')
    "#{new_resource.install_dir}/flyway-#{node['flywaydb']['version']}"
  else
    new_resource.install_dir
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
      exec = Mixlib::ShellOut.new(cmd)
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
