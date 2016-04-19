include_recipe 'apt' if platform?('ubuntu')

mysql_service 'default' do
  version node['flywaydb_test']['mysql']['version']
  bind_address '0.0.0.0'
  port '3306'
  initial_root_password 'mysql'
  action [:create, :start]
end
