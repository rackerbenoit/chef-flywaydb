default['flywaydb']['version'] = '4.0.1'
default['flywaydb']['mysql']['version'] = '5.1.38'

default['flywaydb']['user'] = 'flyway'
default['flywaydb']['group'] = 'flyway'

case node['platform_family']
when 'windows'
  default['flywaydb']['install_dir'] = ENV['SYSTEMDRIVE']
  default['flywaydb']['url'] = 'https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/' \
    "#{node['flywaydb']['version']}/flyway-commandline-#{node['flywaydb']['version']}-windows-x64.zip"
  default['flywaydb']['sha256'] = '2288e69efef21f9de2b26379ddb547a9b23ece7de1c9341a2ee72f9da31568f7'
  default['flywaydb']['mysql']['url'] = 'https://dev.mysql.com/get/Downloads/Connector-J/' \
    "mysql-connector-java-#{node['flywaydb']['mysql']['version']}.zip"
  default['flywaydb']['mysql']['sha256'] = '6374dd729c96068b40cbdd9e42639b08f39c1b46260cfb4e58665e4b7d13322c'
else
  default['flywaydb']['install_dir'] = '/opt'
  default['flywaydb']['url'] = 'https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/' \
    "#{node['flywaydb']['version']}/flyway-commandline-#{node['flywaydb']['version']}-linux-x64.tar.gz"
  default['flywaydb']['sha256'] = 'f2cdc44f47dd0d10bb8fd7e34963982758454ffcb01216e314f8ac51c6decd08'
  default['flywaydb']['mysql']['url'] = 'https://dev.mysql.com/get/Downloads/Connector-J/' \
    "mysql-connector-java-#{node['flywaydb']['mysql']['version']}.tar.gz"
  default['flywaydb']['mysql']['sha256'] = 'fa6232a0bcf67dc7d9acac9dc58910644e50790cbd8cc2f854e2c17f91b2c224'
end
