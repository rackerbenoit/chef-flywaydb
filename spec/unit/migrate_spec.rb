# Encoding: utf-8

require_relative 'spec_helper'

describe 'flywaydb_test::migrate' do
  describe 'linux' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        platform: 'centos',
        version: '7.0',
        file_cache_path: '/etc/chef',
        step_into: ['flywaydb'],
        log_level: ::LOG_LEVEL) do |node|
        node.set['flywaydb_test']['params'] = {
          user: 'mysql',
          password: 'mysql'
        }
        node.set['flywaydb_test']['conf'] = {
          url: 'jdbc:mysql://localhost/mysql'
        }
        node.set['flywaydb_test']['sensitive'] = false
      end.converge(described_recipe)
    end

    it 'migrates db' do
      expect(chef_run).to migrate_flywaydb('flyway').with(
        params: {
          'user' => 'mysql',
          'password' => 'mysql'
        },
        conf: {
          'url' => 'jdbc:mysql://localhost/mysql'
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
          conf: {
            'url' => 'jdbc:mysql://localhost/mysql'
          }
        },
        owner: 'flyway',
        group: 'flyway'
      )
    end

    it 'executes flyway migrate' do
      expect(chef_run).to run_execute('flyway migrate /opt/flyway/conf/flyway.conf').with(
        command: "/opt/flyway/flyway -user='mysql' -password='mysql'" \
          " -configFile='/opt/flyway/conf/flyway.conf' migrate"
      )
    end
  end

  describe 'windows' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        platform: 'windows',
        version: '2012R2',
        file_cache_path: 'C:\\chef\\cache',
        step_into: ['flywaydb'],
        log_level: ::LOG_LEVEL) do |node|
        ENV['SYSTEMDRIVE'] = 'C:'
        node.set['flywaydb_test']['params'] = {
          user: 'mysql',
          password: 'mysql'
        }
        node.set['flywaydb_test']['conf'] = [
          {
            url: 'jdbc:mysql://localhost/mysql',
            schemas: 'schema_a'
          },
          {
            url: 'jdbc:mysql://localhost/mysql',
            schemas: 'schema_b'
          }
        ]
        node.set['flywaydb_test']['debug'] = true
        node.set['flywaydb_test']['sensitive'] = true
      end.converge(described_recipe)
    end

    it 'migrates db' do
      expect(chef_run).to migrate_flywaydb('flyway').with(
        params: {
          'user' => 'mysql',
          'password' => 'mysql'
        },
        conf: [
          {
            'url' => 'jdbc:mysql://localhost/mysql',
            'schemas' => 'schema_a'
          },
          {
            'url' => 'jdbc:mysql://localhost/mysql',
            'schemas' => 'schema_b'
          }
        ],
        debug: true,
        sensitive: true
      )
    end

    it 'creates conf file on flyway_1' do
      expect(chef_run).to create_template('C:\flyway/conf/flyway_1.conf').with(
        source: 'flyway.conf.erb',
        sensitive: true,
        variables: {
          conf: {
            'url' => 'jdbc:mysql://localhost/mysql',
            'schemas' => 'schema_a'
          }
        },
        owner: 'flyway',
        group: 'flyway'
      )
    end

    it 'executes flyway migrate on flyway_1' do
      expect(chef_run).to run_execute('flyway migrate C:\flyway/conf/flyway_1.conf').with(
        command: 'C:\\flyway/flyway -user="mysql" -password="mysql" ' \
          '-configFile="C:\\flyway/conf/flyway_1.conf" -X migrate'
      )
    end

    it 'creates conf file on flyway_2' do
      expect(chef_run).to create_template('C:\flyway/conf/flyway_2.conf').with(
        source: 'flyway.conf.erb',
        sensitive: true,
        variables: {
          conf: {
            'url' => 'jdbc:mysql://localhost/mysql',
            'schemas' => 'schema_b'
          }
        },
        owner: 'flyway',
        group: 'flyway'
      )
    end

    it 'executes flyway migrate on flyway_2' do
      expect(chef_run).to run_execute('flyway migrate C:\flyway/conf/flyway_2.conf').with(
        command: 'C:\\flyway/flyway -user="mysql" -password="mysql" ' \
          '-configFile="C:\\flyway/conf/flyway_2.conf" -X migrate'
      )
    end
  end
end
