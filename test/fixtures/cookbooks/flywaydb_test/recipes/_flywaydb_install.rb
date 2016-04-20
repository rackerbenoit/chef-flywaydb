flywaydb 'install with password' do
  password node['flywaydb_test']['password']
  action :install
end
