use_inline_resources

def whyrun_supported?
  true
end

def install_flyway
  recipe_eval do
    run_context.include_recipe 'flywaydb::default'
  end unless run_context.loaded_recipe? 'flywaydb::default'
end

def validate_attributes
  if new_resource.name.casecmp('flyway').zero? && !new_resource.flyway_conf.nil?
    raise "Flywaydb resource block name cannot be 'flyway'!"
  end

  if new_resource.flyway_conf.nil? && new_resource.alt_conf.nil? && new_resource.params.nil?
    raise('Flywaydb requires at least one following attributes to be defined: flyway_conf, alt_conf, or params!')
  end
end

def build_command(command, conf_path)
  cmd = ["#{new_resource.install_dir}/flyway"]
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
  conf_path = "#{new_resource.install_dir}/conf/#{conf_name}.conf"
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
      source "file://#{resource_obj.tr('file://', '')}"
    end

    exec_flyway(command, conf_path) if run
  else
    raise 'Unsupported resource object!'
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

  unless new_resource.flyway_conf.nil?
    run = new_resource.alt_conf.nil? ? true : false
    process_conf(new_resource.flyway_conf, command, 'flyway', run)
  end

  process_conf(new_resource.alt_conf, command, new_resource.name.tr(' ', '_'), true) unless new_resource.alt_conf.nil?
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
