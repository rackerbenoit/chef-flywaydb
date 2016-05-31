# Encoding: utf-8

require_relative 'spec_helper'

describe 'flywaydb_test::default' do
  describe 'test setup' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        platform: 'centos',
        version: '7.0',
        # file_cache_path: '/etc/chef/cache',
        step_into: ['flywaydb'],
        log_level: ::LOG_LEVEL
      ) do |node|
        node.set['flywaydb_test']['params'] = {
          password: 'mysql',
          'placeholders.test_password' => 'test'
        }
        node.set['flywaydb_test']['flyway_conf'] = {
          user: 'notset',
          url: 'jdbc:mysql://notset/mysql',
          schemas: 'flywaydb_test',
          locations: 'filesystem:/tmp/db',
          cleanDisabled: true,
          'placeholders.test_user' => 'test'
        }
        node.set['flywaydb_test']['alt_conf'] = {
          user: 'root',
          url: 'jdbc:mysql://localhost/mysql'
        }
        node.set['flywaydb_test']['mysql_driver'] = true
        node.set['flywaydb_test']['sensitive'] = false
      end.converge(described_recipe)
    end

    it 'installs flyway' do
      expect(chef_run).to install_flywaydb('install with password')
    end

    it 'downloads mariadb driver' do
      expect(chef_run).to create_remote_file(
        '/opt/flyway-4.0.1/drivers/mariadb-java-client-1.4.5.jar'
      ).with(
        source: 'http://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/1.4.5/mariadb-java-client-1.4.5.jar'
      )
    end

    it 'remove mariadb-java-client' do
      expect(chef_run).to run_ruby_block('remove mariadb-java-client')
    end

    it 'downloads mysql driver' do
      expect(chef_run).to create_remote_file(
        '/opt/flyway-4.0.1/drivers/mysql-connector-java-5.1.39.jar'
      ).with(
        source: 'http://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.39/mysql-connector-java-5.1.39.jar'
      )
    end

    it 'remove mysql-connector-java' do
      expect(chef_run).to run_ruby_block('remove mysql-connector-java')
    end

    it 'creates tmp db dir' do
      expect(chef_run).to create_directory('/tmp/db')
    end

    it 'creates V001__schema.sql' do
      expect(chef_run).to create_cookbook_file('V001__schema.sql')
    end

    it 'creates V002__data.sql' do
      expect(chef_run).to create_cookbook_file('V002__data.sql')
    end

    it 'creates V003__user_grants.sql' do
      expect(chef_run).to create_cookbook_file('V003__user_grants.sql')
    end

    it 'creates tmp conf dir' do
      expect(chef_run).to create_directory('/tmp/conf')
    end

    it 'creates flyway_test.conf file' do
      expect(chef_run).to create_cookbook_file('ext_conf').with(
        source: 'ext.conf',
        path: '/tmp/conf/ext.conf'
      )
    end

    it 'creates legacy dir' do
      expect(chef_run).to create_directory('/opt/flyway')
    end

    it 'moves legacy dir' do
      expect(chef_run).to_not run_ruby_block('mv legacy /opt/flyway dir')
    end
  end

  describe 'single migration on linux' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        platform: 'centos',
        version: '7.0',
        # file_cache_path: '/etc/chef/cache',
        step_into: ['flywaydb'],
        log_level: ::LOG_LEVEL
      ) do |node|
        node.set['flywaydb_test']['params'] = {
          password: 'mysql',
          'placeholders.test_password' => 'test'
        }
        node.set['flywaydb_test']['flyway_conf'] = {
          user: 'notset',
          url: 'jdbc:mysql://notset/mysql',
          schemas: 'flywaydb_test',
          locations: 'filesystem:/tmp/db',
          cleanDisabled: true,
          'placeholders.test_user' => 'test'
        }
        node.set['flywaydb_test']['alt_conf'] = {
          user: 'root',
          url: 'jdbc:mysql://localhost/mysql'
        }
        node.set['flywaydb_test']['mysql_driver'] = true
        node.set['flywaydb_test']['sensitive'] = false
      end.converge(described_recipe)
    end

    it 'migrates db' do
      expect(chef_run).to migrate_flywaydb('flyway_test').with(
        params: {
          'password' => 'mysql',
          'placeholders.test_password' => 'test'
        },
        flyway_conf: {
          'user' => 'notset',
          'url' => 'jdbc:mysql://notset/mysql',
          'schemas' => 'flywaydb_test',
          'locations' => 'filesystem:/tmp/db',
          'cleanDisabled' => true,
          'placeholders.test_user' => 'test'
        },
        alt_conf: {
          'user' => 'root',
          'url' => 'jdbc:mysql://localhost/mysql'
        },
        debug: false,
        sensitive: false
      )
    end

    it 'creates flyway.conf file' do
      expect(chef_run).to create_template("/opt/flyway-#{VERSION}/conf/flyway.conf").with(
        source: 'flyway.conf.erb',
        sensitive: false,
        variables: {
          conf: {
            'user' => 'notset',
            'url' => 'jdbc:mysql://notset/mysql',
            'schemas' => 'flywaydb_test',
            'locations' => 'filesystem:/tmp/db',
            'cleanDisabled' => true,
            'placeholders.test_user' => 'test'
          }
        },
        owner: 'flyway',
        group: 'flyway'
      )
    end

    it 'creates flyway_test.conf file' do
      expect(chef_run).to create_template("/opt/flyway-#{VERSION}/conf/flyway_test.conf").with(
        source: 'flyway.conf.erb',
        sensitive: false,
        variables: {
          conf: {
            'user' => 'root',
            'url' => 'jdbc:mysql://localhost/mysql'
          }
        },
        owner: 'flyway',
        group: 'flyway'
      )
    end

    it 'executes flyway migrate' do
      expect(chef_run).to run_ruby_block("flyway migrate /opt/flyway-#{VERSION}/conf/flyway_test.conf")
    end

    it 'creates flyway link' do
      expect(chef_run).to create_link('/opt/flyway').with(
        to: "/opt/flyway-#{VERSION}"
      )
    end
  end

  describe 'multiple migrations on windows' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        platform: 'windows',
        version: '2012R2',
        # file_cache_path: 'C:/chef/cache',
        step_into: ['flywaydb'],
        log_level: ::LOG_LEVEL
      ) do |node|
        ENV['SYSTEMDRIVE'] = 'C:'
        node.set['flywaydb_test']['params'] = {
          password: 'mysql'
        }
        node.set['flywaydb_test']['flyway_conf'] = {
          user: 'mysql',
          password: 'notset',
          url: 'jdbc:mysql://notset/mysql'
        }
        node.set['flywaydb_test']['alt_conf'] = [
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

    it 'downloads mysql driver' do
      expect(chef_run).to create_remote_file(
        'C:/flyway-4.0.1/drivers/mariadb-java-client-1.4.5.jar'
      ).with(
        source: 'http://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/1.4.5/mariadb-java-client-1.4.5.jar'
      )
    end

    it 'migrates db' do
      expect(chef_run).to migrate_flywaydb('flyway_test').with(
        params: {
          'password' => 'mysql'
        },
        flyway_conf: {
          'user' => 'mysql',
          'password' => 'notset',
          'url' => 'jdbc:mysql://notset/mysql'
        },
        alt_conf: [
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

    it 'creates flyway.conf file' do
      expect(chef_run).to create_template("C:/flyway-#{VERSION}/conf/flyway.conf").with(
        source: 'flyway.conf.erb',
        sensitive: true,
        variables: {
          conf: {
            'user' => 'mysql',
            'password' => 'notset',
            'url' => 'jdbc:mysql://notset/mysql'
          }
        },
        owner: 'flyway',
        group: 'flyway'
      )
    end

    it 'creates flyway_test_1.conf' do
      expect(chef_run).to create_template("C:/flyway-#{VERSION}/conf/flyway_test_1.conf").with(
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
      expect(chef_run).to_not run_ruby_block("flyway migrate C:/flyway-#{VERSION}/conf/flyway_test_1.conf")
    end

    it 'creates flyway_test_2.conf' do
      expect(chef_run).to create_template("C:/flyway-#{VERSION}/conf/flyway_test_2.conf").with(
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
      expect(chef_run).to_not run_ruby_block("flyway migrate C:/flyway-#{VERSION}/conf/flyway_test_2.conf")
    end

    it 'creates flyway link' do
      expect(chef_run).to create_link('C:/flyway').with(
        to: "C:/flyway-#{VERSION}"
      )
    end

    it 'creates legacy dir' do
      expect(chef_run).to_not create_directory('C:/flyway')
    end

    it 'moves legacy dir' do
      expect(chef_run).to_not run_ruby_block('mv legacy C:/flyway dir')
    end
  end
end
