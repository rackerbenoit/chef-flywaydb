use_inline_resources

def whyrun_supported?
  true
end

def build_command(command, conf_path)
  cmd = ["#{new_resource.install_dir}/flyway"]
  new_resource.params.each do |key, value|
    cmd << (platform?('windows') ? "-#{key}=\"#{value}\"" : "-#{key}='#{value}'")
  end
  cmd << (platform?('windows') ? "-configFile=\"#{conf_path}\"" : "-configFile='#{conf_path}'")
  cmd << '-X' if new_resource.debug
  cmd << command
end

def write_conf(conf_path, conf)
  template conf_path do
    source 'flyway.conf.erb'
    sensitive new_resource.sensitive
    variables(conf: conf)
    cookbook 'flywaydb'
    owner new_resource.user
    group new_resource.group
  end
end

def process_conf(command, conf_name)
  if new_resource.conf.respond_to?(:key)
    conf_path = "#{new_resource.install_dir}/conf/#{conf_name}.conf"
    write_conf(conf_path, new_resource.conf)
    exec_flyway(command, conf_path)
  else
    new_resource.conf.each_with_index do |h, i|
      conf_path = "#{new_resource.install_dir}/conf/#{conf_name}_#{i + 1}.conf"
      write_conf(conf_path, h)
      exec_flyway(command, conf_path)
    end
  end
end

def process_ext_conf(command)
  if new_resource.ext_conf.is_a?(Array)
    new_resource.ext_conf.each do |conf_path|
      exec_flyway(command, conf_path)
    end
  else
    exec_flyway(command, new_resource.ext_conf)
  end
end

def exec_flyway(command, conf_path)
  cmd = build_command(command, conf_path)

  execute "flyway #{command} #{conf_path}" do
    command cmd.join(' ')
    sensitive new_resource.sensitive
  end
end

def flyway(command)
  if new_resource.conf.nil? && new_resource.ext_conf.nil? && new_resource.params.empty?
    raise('Flyway requires at least one following attributes to be defined: conf, ext_conf, or params!')
  end

  recipe_eval { run_context.include_recipe 'flywaydb::default' }

  if new_resource.ext_conf.nil?
    conf_name = new_resource.name.tr(' ', '_')
    process_conf(command, conf_name)
  else
    process_ext_conf(command)
  end
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
