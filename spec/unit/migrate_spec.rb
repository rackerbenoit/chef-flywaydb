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

    it 'creates conf file' do
      expect(chef_run).to create_template('/opt/flyway/conf/flyway.conf').with(
        source: 'flyway.conf.erb',
        sensitive: false,
        variables: {
          'url' => 'jdbc:mysql://localhost/mysql',
          'user' => 'mysql',
          'password' => 'mysql'
        },
        owner: 'flyway'
      )
    end

    it 'executes flyway migrate' do
      expect(chef_run).to run_execute('flyway -configFile=/opt/flyway/conf/flyway.conf migrate')
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
        node.set['flywaydb']['conf'] = [
          {
            url: 'jdbc:mysql://localhost/mysql',
            user: 'mysql',
            password: 'mysql',
            schemas: 'schema_a'
          },
          {
            url: 'jdbc:mysql://localhost/mysql',
            user: 'mysql',
            password: 'mysql',
            schemas: 'schema_b'
          }
        ]
        node.set['flywaydb']['debug'] = true
        node.set['flywaydb']['sensitive'] = true
      end.converge(described_recipe)
    end

    it 'migrates db' do
      expect(chef_run).to migrate_flywaydb('flyway').with(
        conf: [
          {
            'url' => 'jdbc:mysql://localhost/mysql',
            'user' => 'mysql',
            'password' => 'mysql',
            'schemas' => 'schema_a'
          },
          {
            'url' => 'jdbc:mysql://localhost/mysql',
            'user' => 'mysql',
            'password' => 'mysql',
            'schemas' => 'schema_b'
          }
        ],
        debug: true,
        sensitive: true
      )
    end

    it 'creates conf file' do
      expect(chef_run).to create_template('C:/flyway/conf/flyway_1.conf').with(
        source: 'flyway.conf.erb',
        sensitive: true,
        variables: {
          'url' => 'jdbc:mysql://localhost/mysql',
          'user' => 'mysql',
          'password' => 'mysql',
          'schemas' => 'schema_a'
        },
        owner: 'flyway'
      )
    end

    it 'executes flyway migrate' do
      expect(chef_run).to run_execute('flyway -configFile=C:/flyway/conf/flyway_1.conf -X migrate')
    end

    it 'creates conf file' do
      expect(chef_run).to create_template('C:/flyway/conf/flyway_2.conf').with(
        source: 'flyway.conf.erb',
        sensitive: true,
        variables: {
          'url' => 'jdbc:mysql://localhost/mysql',
          'user' => 'mysql',
          'password' => 'mysql',
          'schemas' => 'schema_b'
        },
        owner: 'flyway'
      )
    end

    it 'executes flyway migrate' do
      expect(chef_run).to run_execute('flyway -configFile=C:/flyway/conf/flyway_2.conf -X migrate')
    end
  end
end
