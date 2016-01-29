# Encoding: utf-8

require_relative 'spec_helper'

describe 'flywaydb::migrate' do
  describe 'linux' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        platform: 'centos',
        version: '7.0',
        file_cache_path: '/etc/chef',
        step_into: ['flywaydb'],
        log_level: ::LOG_LEVEL) do |node|
        node.set['flywaydb']['conf'] = {
          url: 'jdbc:mysql://localhost/mysql',
          user: 'mysql',
          password: 'mysql'
        }
      end.converge(described_recipe)
    end

    it 'migrates db' do
      expect(chef_run).to migrate_flywaydb('flyway').with(
        conf: {
          'url' => 'jdbc:mysql://localhost/mysql',
          'user' => 'mysql',
          'password' => 'mysql'
        },
        debug: false,
        sensitive: false
      )
    end
  end

  describe 'windows' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        platform: 'windows',
        version: '2012R2',
        file_cache_path: 'C:\chef',
        step_into: ['flywaydb'],
        log_level: ::LOG_LEVEL) do |node|
        ENV['SYSTEMDRIVE'] = 'C:'
        node.set['flywaydb']['conf'] = {
          url: 'jdbc:mysql://localhost/mysql',
          user: 'mysql',
          password: 'mysql'
        }
        node.set['flywaydb']['debug'] = true
        node.set['flywaydb']['sensitive'] = true
      end.converge(described_recipe)
    end

    it 'migrates db' do
      expect(chef_run).to migrate_flywaydb('flyway').with(
        conf: {
          'url' => 'jdbc:mysql://localhost/mysql',
          'user' => 'mysql',
          'password' => 'mysql'
        },
        debug: true,
        sensitive: true
      )
    end
  end
end
