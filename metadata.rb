# Encoding: utf-8
name 'flywaydb'
maintainer 'Dennis Hoer'
maintainer_email 'dennis.hoer@gmail.com'
license 'MIT'
description 'Installs and configures flywaydb database migration tool'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '5.0.1'

supports 'centos', '>= 6.0'
supports 'redhat', '>= 6.0'
supports 'ubuntu', '>= 14.04'
supports 'windows'

source_url 'https://github.com/dhoer/chef-flywaydb' if respond_to?(:source_url)
issues_url 'https://github.com/dhoer/chef-flywaydb/issues' if respond_to?(:issues_url)
