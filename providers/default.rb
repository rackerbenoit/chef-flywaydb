use_inline_resources

def whyrun_supported?
  true
end

def process_conf(command, conf_path, h)
  template conf_path do
    source 'flyway.conf.erb'
    sensitive new_resource.sensitive
    variables(h)
    owner new_resource.user
  end

  execute "flyway -configFile=#{conf_path}#{new_resource.debug ? ' -X' : nil} #{command}"
end

def execute_flyway(command)
  recipe_eval { run_context.include_recipe 'flywaydb::default' }

  conf_name = new_resource.name.tr(' ', '_')

  if new_resource.conf.respond_to?(:key)
    conf_path = "#{new_resource.install_dir}/flyway/conf/#{conf_name}.conf"
    process_conf(command, conf_path, new_resource.conf)
  else
    new_resource.conf.each_with_index do |h, i|
      conf_path = "#{new_resource.install_dir}/flyway/conf/#{conf_name}_#{i + 1}.conf"
      process_conf(command, conf_path, h)
    end
  end
end

action :migrate do
  converge_by('migrate') do
    execute_flyway('migrate')
  end
end

action :clean do
  converge_by('migrate') do
    execute_flyway('migrate')
  end
end

action :info do
  converge_by('info') do
    execute_flyway('info')
  end
end

action :validate do
  converge_by('validate') do
    execute_flyway('validate')
  end
end

action :baseline do
  converge_by('baseline') do
    execute_flyway('baseline')
  end
end

action :repair do
  converge_by('repair') do
    execute_flyway('repair')
  end
end
