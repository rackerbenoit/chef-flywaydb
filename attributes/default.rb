default['flywaydb']['version'] = '4.0'
default['flywaydb']['base_url'] = 'https://repo1.maven.org/maven2'

v = node['flywaydb']['version']

case node['platform_family']
when 'debian', 'rhel'
  default['flywaydb']['sha256'] = '2a91502a0dd5e88b407ed56ba8403f1bb77e013784bcb34420c306b5bac2b476'
  default['flywaydb']['url'] =
    "#{node['flywaydb']['base_url']}/org/flywaydb/flyway-commandline/#{v}/flyway-commandline-#{v}-linux-x64.tar.gz"
  default['flywaydb']['install_dir'] = '/opt/flyway'
when 'windows'
  default['flywaydb']['sha256'] = '985eb7d0cafd5eb59df3c825292b6bb387466f0f11e35eb2295f6b3a78b5821c'
  default['flywaydb']['url'] =
    "#{node['flywaydb']['base_url']}/org/flywaydb/flyway-commandline/#{v}/flyway-commandline-#{v}-windows-x64.zip"
  default['flywaydb']['install_dir'] = "#{ENV['SYSTEMDRIVE']}\\flyway"
end

default['flywaydb']['name'] = 'flyway'
default['flywaydb']['user'] = 'flyway'
default['flywaydb']['group'] = 'flyway'
