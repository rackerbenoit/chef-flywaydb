include_recipe 'flywaydb_test::_mysql'
include_recipe 'flywaydb_test::_scripts_setup'

directory '/tmp/conf' do
  action :create
end

cookbook_file 'ext_conf' do
  path '/tmp/conf/ext.conf'
  source 'ext.conf'
end

flywaydb 'ext_conf' do
  ext_conf node['flywaydb']['ext_conf']
  params node['flywaydb']['params']
  debug node['flywaydb']['debug']
  sensitive node['flywaydb']['sensitive']
  action :migrate
end
