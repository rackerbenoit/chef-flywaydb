include_recipe 'yum-mysql-community:mysql57' if platform?('centos')

mysql_service 'default' do
  version node['flywaydb_test']['mysql']['version']
  bind_address '0.0.0.0'
  port '3306'
  initial_root_password 'mysql'
  action %i(create start)
end
