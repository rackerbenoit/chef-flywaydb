include_recipe 'flywaydb_test::_flywaydb_install'
include_recipe 'flywaydb_test::_mysql_scripts_setup'
include_recipe 'flywaydb_test::_flywaydb_migrate'
