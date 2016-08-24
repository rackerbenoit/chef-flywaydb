# Encoding: utf-8

require_relative 'spec_helper'

describe 'flywaydb::default' do
  describe 'linux' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        platform: 'centos',
        version: '7.0',
        step_into: 'flywaydb',
        log_level: ::LOG_LEVEL
      ).converge(described_recipe)
    end

    it 'installs flyway' do
      expect(chef_run).to install_flywaydb('install flywaydb')
    end

    it 'creates user' do
      expect(chef_run).to create_user('flyway')
    end

    it 'creates group' do
      expect(chef_run).to create_group('flyway')
    end

    it 'creates install directory' do
      expect(chef_run).to create_directory('/opt/flywaydb')
    end

    it 'downloads flyway cli' do
      expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}" \
      "/flyway-commandline-#{VERSION}-linux-x64.tar.gz").with(
        source: "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/#{VERSION}/" \
        "flyway-commandline-#{VERSION}-linux-x64.tar.gz"
      )
    end

    it 'untars flyway cli' do
      expect(chef_run).to_not run_execute('extract flyway')
    end

    it 'make flyway executable' do
      expect(chef_run).to run_execute('chmod +x /opt/flywaydb/flyway/flyway')
    end
  end

  describe 'windows' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        platform: 'windows',
        version: '2012R2',
        step_into: 'flywaydb',
        log_level: ::LOG_LEVEL
      ) do
        ENV['SYSTEMDRIVE'] = 'C:'
      end.converge(described_recipe)
    end

    it 'creates user' do
      expect(chef_run).to create_user('flyway')
    end

    it 'creates group' do
      expect(chef_run).to create_group('Administrators')
    end

    it 'creates install directory' do
      expect(chef_run).to create_directory('C:/flywaydb')
    end

    it 'downloads flyway cli' do
      expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}" \
      "/flyway-commandline-#{VERSION}-windows-x64.zip").with(
        source: "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/#{VERSION}/" \
          "flyway-commandline-#{VERSION}-windows-x64.zip"
      )
    end

    it 'unzips flyway cli' do
      expect(chef_run).to_not run_batch('unzip flyway (powershell 3 or higher required)')
    end

    it 'does not make flyway executable' do
      expect(chef_run).to_not run_execute('chmod +x C:/flywaydb/flyway/flyway')
    end
  end
end
