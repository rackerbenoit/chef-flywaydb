property :conf, kind_of: [Hash, Array], required: true
property :sensitive, kind_of: [TrueClass, FalseClass], default: false
property :debug, kind_of: [TrueClass, FalseClass], default: false
property :install_dir, kind_of: String, default: '/opt'
property :user, kind_of: String, default: 'flyway'

default_action :migrate

def process_conf(command, conf_path, h)
  template conf_path do
    source 'flyway.conf.erb'
    sensitive new_resource.sensitive
    variables(h)
    owner new_resource.user
  end

  execute "flyway -configFile=#{conf_path}#{debug ? ' -X' : nil} #{command}"
end

def execute_flyway(command)
  Chef.run_context.include_recipe('flywaydb::default')

  conf_name = name.gsub(' ', '_')

  if conf.respond_to?(:key)
    conf_path = "#{install_dir}/flyway/conf/#{conf_name}.conf"
    process_conf(command, conf_path, conf)
  else
    conf.each_with_index do |h, i|
      conf_path = "#{install_dir}/flyway/conf/#{conf_name}_#{i + 1}.conf"
      process_conf(command, conf_path, h)
    end
  end
end

action :migrate do
  execute_flyway('migrate')
end

action :clean do
  execute_flyway('clean')
end

action :info do
  execute_flyway('info')
end

action :validate do
  execute_flyway('validate')
end

action :baseline do
  execute_flyway('baseline')
end

action :repair do
  execute_flyway('repair')
end
