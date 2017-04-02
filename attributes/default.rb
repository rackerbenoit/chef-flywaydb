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
default['flywaydb']['mysql']['version'] = '5.1.40'
default['flywaydb']['mysql']['sha256'] = '27a80bf2e36d9d08d1be93f70d3124633a6952fe3b95833306905dcba6bfe96d'
default['flywaydb']['mysql']['url'] = 'http://repo1.maven.org/maven2/mysql/mysql-connector-java/' \
  "#{node['flywaydb']['mysql']['version']}/mysql-connector-java-#{node['flywaydb']['mysql']['version']}.jar"

case node['platform_family']
when 'windows'
  default['flywaydb']['install_dir'] = "#{ENV['SYSTEMDRIVE']}/flywaydb"
  default['flywaydb']['url'] = 'https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/' \
    "#{node['flywaydb']['version']}/flyway-commandline-#{node['flywaydb']['version']}-windows-x64.zip"
  default['flywaydb']['sha256'] = '4bf880a1e9421d55490129f2e435152c83d78142624edb1f83ab953a49468fdf'
else
  default['flywaydb']['install_dir'] = '/opt/flywaydb'
  default['flywaydb']['url'] = 'https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/' \
    "#{node['flywaydb']['version']}/flyway-commandline-#{node['flywaydb']['version']}-linux-x64.tar.gz"
  default['flywaydb']['sha256'] = 'db6107bd04bb8fce838543690b5eb3ea264c8701e4f7907e8f5e6becc6e7ade8'
end
