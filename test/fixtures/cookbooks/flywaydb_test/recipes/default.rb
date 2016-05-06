directory "#{node['flywaydb']['install_dir']}/flyway" do # test moving legacy dir
  not_if { platform?('windows') }
end

include_recipe 'flywaydb_test::_flywaydb_install'
include_recipe 'flywaydb_test::_mysql_scripts_setup'
include_recipe 'flywaydb_test::_flywaydb_migrate'
