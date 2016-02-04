include_recipe 'flywaydb_test::_mysql'
include_recipe 'flywaydb_test::_scripts_setup'

include_recipe 'flywaydb::migrate'
