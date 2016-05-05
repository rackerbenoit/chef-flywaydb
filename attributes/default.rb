default['flywaydb']['version'] = '4.0'
default['flywaydb']['mysql']['version'] = '5.1.38'

default['flywaydb']['user'] = 'flyway'
default['flywaydb']['group'] = 'flyway'

case node['platform_family']
when 'debian', 'rhel'
  default['flywaydb']['install_dir'] = '/opt'
  default['flywaydb']['url'] = 'https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/' \
    "#{node['flywaydb']['version']}/flyway-commandline-#{node['flywaydb']['version']}-linux-x64.tar.gz"
  default['flywaydb']['sha256'] = '2a91502a0dd5e88b407ed56ba8403f1bb77e013784bcb34420c306b5bac2b476'
  default['flywaydb']['mysql']['url'] = 'https://dev.mysql.com/get/Downloads/Connector-J/' \
    "mysql-connector-java-#{node['flywaydb']['mysql']['version']}.tar.gz"
  default['flywaydb']['mysql']['sha256'] = 'fa6232a0bcf67dc7d9acac9dc58910644e50790cbd8cc2f854e2c17f91b2c224'
when 'windows'
  default['flywaydb']['install_dir'] = ENV['SYSTEMDRIVE']
  default['flywaydb']['url'] = 'https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/' \
    "#{node['flywaydb']['version']}/flyway-commandline-#{node['flywaydb']['version']}-windows-x64.zip"
  default['flywaydb']['sha256'] = '985eb7d0cafd5eb59df3c825292b6bb387466f0f11e35eb2295f6b3a78b5821c'
  default['flywaydb']['mysql']['url'] = 'https://dev.mysql.com/get/Downloads/Connector-J/' \
    "mysql-connector-java-#{node['flywaydb']['mysql']['version']}.zip"
  default['flywaydb']['mysql']['sha256'] = '6374dd729c96068b40cbdd9e42639b08f39c1b46260cfb4e58665e4b7d13322c'
end
