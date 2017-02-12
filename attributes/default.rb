default['flywaydb']['version'] = '4.1.0'
default['flywaydb']['user'] = nil # creates flyway user when nil
default['flywaydb']['group'] = nil # creates flyway or modifies Windows Administrators group when nil
default['flywaydb']['timeout'] = 259_200 # 72hrs

# https://mariadb.com/kb/en/mariadb/about-mariadb-connector-j/
default['flywaydb']['mariadb']['version'] = nil
default['flywaydb']['mariadb']['sha256'] = nil
default['flywaydb']['mariadb']['url'] = 'http://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/' \
  "#{node['flywaydb']['mariadb']['version']}/mariadb-java-client-#{node['flywaydb']['mariadb']['version']}.jar"

# http://dev.mysql.com/doc/relnotes/connector-j/5.1/en/news-5-1.html
default['flywaydb']['mysql']['version'] = '5.1.40'
default['flywaydb']['mysql']['sha256'] = '668330de57485999cdbbcad22ea21159a0fc3711f11ccbca7b12b65195fa7539'
default['flywaydb']['mysql']['url'] = 'http://repo1.maven.org/maven2/mysql/mysql-connector-java/' \
  "#{node['flywaydb']['mysql']['version']}/mysql-connector-java-#{node['flywaydb']['mysql']['version']}.jar"

case node['platform_family']
when 'windows'
  default['flywaydb']['install_dir'] = "#{ENV['SYSTEMDRIVE']}/flywaydb"
  default['flywaydb']['url'] = 'https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/' \
    "#{node['flywaydb']['version']}/flyway-commandline-#{node['flywaydb']['version']}-windows-x64.zip"
  default['flywaydb']['sha256'] = '845a4013f3112a57d698db8701d8ffab79d2d0a98ce626bbc7a989aca94c6ee4'
else
  default['flywaydb']['install_dir'] = '/opt/flywaydb'
  default['flywaydb']['url'] = 'https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/' \
    "#{node['flywaydb']['version']}/flyway-commandline-#{node['flywaydb']['version']}-linux-x64.tar.gz"
  default['flywaydb']['sha256'] = '6d5f23429b75c2f69a51758fed98572ee47ae92e6cc7fa2ff896d81be8fcb055'
end
