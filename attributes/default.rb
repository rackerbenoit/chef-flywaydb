default['flywaydb']['version'] = '3.2.1'
default['flywaydb']['base_url'] = 'https://bintray.com/artifact/download/business/maven'

case node['platform_family']
when 'debian', 'rhel'
  default['flywaydb']['sha256'] = '8b9ba320a69b8cdef6de60118e312d3cbe96ca37a24b8aec7be4cdf4950bb5fe'
  default['flywaydb']['url'] =
    "#{node['flywaydb']['base_url']}/flyway-commandline-#{node['flywaydb']['version']}-linux-x64.tar.gz"
  default['flywaydb']['install_dir'] = '/opt/flyway'
when 'windows'
  default['flywaydb']['sha256'] = '83c4632548fc018f95af71bf41269321b967a1a0bce3af478338f715d085d429'
  default['flywaydb']['url'] =
    "#{node['flywaydb']['base_url']}/flyway-commandline-#{node['flywaydb']['version']}-windows-x64.zip"
  default['flywaydb']['install_dir'] = "#{ENV['SYSTEMDRIVE']}\\flyway"
end

default['flywaydb']['name'] = 'flyway'
default['flywaydb']['user'] = 'flyway'
default['flywaydb']['group'] = 'flyway'
