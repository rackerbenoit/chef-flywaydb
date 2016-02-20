include_recipe 'flywaydb_test::_mysql'
include_recipe 'flywaydb_test::_scripts_setup'

directory '/tmp/conf' do
  action :create
end

cookbook_file 'ext_conf' do
  path '/tmp/conf/ext.conf'
  source 'ext.conf'
end

flywaydb 'flyway' do
  conf node['flywaydb_test']['conf']
  ext_conf node['flywaydb_test']['ext_conf']
  params node['flywaydb_test']['params']
  debug node['flywaydb_test']['debug']
  sensitive node['flywaydb_test']['sensitive']
  action :migrate
end
