default['flywaydb']['version'] = '5.2.1'
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
default['flywaydb']['mysql']['sha256'] = '81c8b2d94247d6db4c3ff2bacfe5c11f552cb6bc56c055b5625dec08d7f045c6'
default['flywaydb']['mysql']['url'] = 'http://repo1.maven.org/maven2/mysql/mysql-connector-java/' \
  "#{node['flywaydb']['mysql']['version']}/mysql-connector-java-#{node['flywaydb']['mysql']['version']}.jar"

# Generate SHA-256 from https://hash.online-convert.com/sha256-generator
case node['platform_family']
when 'windows'
  default['flywaydb']['install_dir'] = "#{ENV['SYSTEMDRIVE']}/flywaydb"
  default['flywaydb']['url'] = 'https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/' \
    "#{node['flywaydb']['version']}/flyway-commandline-#{node['flywaydb']['version']}-windows-x64.zip"
  default['flywaydb']['sha256'] = 'eb49e2941062f72165efa07e39610e0a14b1c9766d0c6c08a843f9831b8ea8c7'
else
  default['flywaydb']['install_dir'] = '/opt/flywaydb'
  default['flywaydb']['url'] = 'https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/' \
    "#{node['flywaydb']['version']}/flyway-commandline-#{node['flywaydb']['version']}-linux-x64.tar.gz"
  default['flywaydb']['sha256'] = '4272f48501132553ede9f484c56081099f9e591c5439fd614418a1da91c5b237'
end
