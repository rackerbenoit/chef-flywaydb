default['flywaydb']['version'] = '4.1.2'
default['flywaydb']['user'] = nil # creates flyway user when nil
default['flywaydb']['group'] = nil # creates flyway or modifies Windows Administrators group when nil
default['flywaydb']['timeout'] = 259_200 # 72hrs

# https://mariadb.com/kb/en/mariadb/about-mariadb-connector-j/
default['flywaydb']['mariadb']['version'] = nil
default['flywaydb']['mariadb']['sha256'] = nil
default['flywaydb']['mariadb']['url'] = 'http://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/' \
  "#{node['flywaydb']['mariadb']['version']}/mariadb-java-client-#{node['flywaydb']['mariadb']['version']}.jar"

# http://dev.mysql.com/doc/relnotes/connector-j/5.1/en/news-5-1.html
default['flywaydb']['mysql']['version'] = '5.1.43'
default['flywaydb']['mysql']['sha256'] = '627c8d6a4956ae905f5445b0dc0d18ecbf88213cee089c998fcf5ced92a9da37'
default['flywaydb']['mysql']['url'] = 'http://repo1.maven.org/maven2/mysql/mysql-connector-java/' \
  "#{node['flywaydb']['mysql']['version']}/mysql-connector-java-#{node['flywaydb']['mysql']['version']}.jar"

case node['platform_family']
when 'windows'
  default['flywaydb']['install_dir'] = "#{ENV['SYSTEMDRIVE']}/flywaydb"
  default['flywaydb']['url'] = 'https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/' \
    "#{node['flywaydb']['version']}/flyway-commandline-#{node['flywaydb']['version']}-windows-x64.zip"
  default['flywaydb']['sha256'] = '99f21d3c634afe23515231ef3c366a7fb447d74d77a59406ac9efd05ab417259'
else
  default['flywaydb']['install_dir'] = '/opt/flywaydb'
  default['flywaydb']['url'] = 'https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/' \
    "#{node['flywaydb']['version']}/flyway-commandline-#{node['flywaydb']['version']}-linux-x64.tar.gz"
  default['flywaydb']['sha256'] = '31e8bfec3aa40a08e3bb184386b19764cee3a48ae4ee3d6328c9bc5836affef7'
end
