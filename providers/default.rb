use_inline_resources

def whyrun_supported?
  true
end

def build_command(command, conf_path)
  cmd = ["#{new_resource.install_dir}/flyway"]
  new_resource.params.each do |key, value|
    cmd << "-#{key}=#{value}"
  end
  cmd << "-configFile=#{conf_path}"
  cmd << '-X' if new_resource.debug
  cmd << '-q' if new_resource.quiet
  cmd << command
end

def process_conf(command, conf_path, conf)
  template conf_path do
    source 'flyway.conf.erb'
    sensitive new_resource.sensitive
    variables(conf: conf)
    owner new_resource.user
    group new_resource.group
  end

  cmd = build_command(command, conf_path)

  execute 'exec flyway' do
    command cmd.join(' ')
    sensitive new_resource.sensitive
  end
end

def flyway(command)
  fail("Flyway #{command} requires conf to be defined!") unless new_resource.conf

  recipe_eval { run_context.include_recipe 'flywaydb::default' }

  conf_name = new_resource.name.tr(' ', '_')

  if new_resource.conf.respond_to?(:key)
    conf_path = "#{new_resource.install_dir}/conf/#{conf_name}.conf"
    process_conf(command, conf_path, new_resource.conf)
  else
    new_resource.conf.each_with_index do |h, i|
      conf_path = "#{new_resource.install_dir}/conf/#{conf_name}_#{i + 1}.conf"
      process_conf(command, conf_path, h)
    end
  end
end

action :migrate do
  converge_by('migrate') do
    flyway('migrate')
  end
end

action :clean do
  converge_by('migrate') do
    flyway('migrate')
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
