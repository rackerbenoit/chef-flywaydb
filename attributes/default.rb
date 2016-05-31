default['flywaydb']['version'] = '4.0.1'
default['flywaydb']['user'] = 'flyway'
default['flywaydb']['group'] = 'flyway'
default['flywaydb']['timeout'] = 259_200

# https://mariadb.com/kb/en/mariadb/about-mariadb-connector-j/
default['flywaydb']['mariadb']['version'] = '1.4.5'
default['flywaydb']['mariadb']['sha256'] = '12206cb77afcd1e178121c2263f92f1cac1481040c74634c3b04edc549dd60ad'
default['flywaydb']['mariadb']['url'] = 'http://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/' \
  "#{node['flywaydb']['mariadb']['version']}/mariadb-java-client-#{node['flywaydb']['mariadb']['version']}.jar"

# http://dev.mysql.com/doc/relnotes/connector-j/5.1/en/news-5-1.html
default['flywaydb']['mysql']['version'] = '5.1.39'
default['flywaydb']['mysql']['sha256'] = 'e3d03342ff17b4093bb71e5878dc331177e40cca172462b8e6b5ec2bb34e7458'
default['flywaydb']['mysql']['url'] = 'http://repo1.maven.org/maven2/mysql/mysql-connector-java/' \
  "#{node['flywaydb']['mysql']['version']}/mysql-connector-java-#{node['flywaydb']['mysql']['version']}.jar"

case node['platform_family']
when 'windows'
  default['flywaydb']['install_dir'] = ENV['SYSTEMDRIVE']
  default['flywaydb']['url'] = 'https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/' \
    "#{node['flywaydb']['version']}/flyway-commandline-#{node['flywaydb']['version']}-windows-x64.zip"
  default['flywaydb']['sha256'] = '2288e69efef21f9de2b26379ddb547a9b23ece7de1c9341a2ee72f9da31568f7'
else
  default['flywaydb']['install_dir'] = '/opt'
  default['flywaydb']['url'] = 'https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/' \
    "#{node['flywaydb']['version']}/flyway-commandline-#{node['flywaydb']['version']}-linux-x64.tar.gz"
  default['flywaydb']['sha256'] = 'f2cdc44f47dd0d10bb8fd7e34963982758454ffcb01216e314f8ac51c6decd08'
end
