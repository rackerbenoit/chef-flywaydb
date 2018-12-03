# Encoding: utf-8

name 'flywaydb'
maintainer 'Paul Benoit'
maintainer_email 'paul.benoit36@gmail.com'
license 'MIT'
description 'Installs and configures flywaydb database migration tool'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/rackerbenoit/chef-flywaydb' if respond_to?(:source_url)
issues_url 'https://github.com/rackerbenoit/chef-flywaydb/issues' if respond_to?(:issues_url)
version '7.3.1'

chef_version '>= 11.0' if respond_to?(:chef_version)

supports 'centos'
supports 'debian'
supports 'redhat'
supports 'ubuntu'
supports 'windows'
