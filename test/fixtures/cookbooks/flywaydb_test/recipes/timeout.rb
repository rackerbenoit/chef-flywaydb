include_recipe 'flywaydb_test::_flywaydb_install'
include_recipe 'flywaydb_test::_mysql_scripts_setup'

cookbook_file 'V004__timeout.sql' do
  path '/tmp/db/V004__timeout.sql'
  source 'V004__timeout.sql'
end

include_recipe 'flywaydb_test::_flywaydb_migrate'
