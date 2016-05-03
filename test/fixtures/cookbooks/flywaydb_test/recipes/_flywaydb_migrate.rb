directory '/tmp/conf' do
  action :create
end

cookbook_file 'ext_conf' do
  path '/tmp/conf/ext.conf'
  source 'ext.conf'
end

flywaydb 'flyway_test' do
  flyway_conf node['flywaydb_test']['flyway_conf']
  alt_conf node['flywaydb_test']['alt_conf']
  params node['flywaydb_test']['params']
  debug node['flywaydb_test']['debug']
  password node['flywaydb_test']['password']
  mysql_driver node['flywaydb_test']['mysql_driver']
  sensitive node['flywaydb_test']['sensitive']
  action :migrate
end
