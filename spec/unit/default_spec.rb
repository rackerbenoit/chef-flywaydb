# Encoding: utf-8

require_relative 'spec_helper'

describe 'flywaydb::default' do
  describe 'linux' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        platform: 'centos',
        version: '7.0',
        file_cache_path: '/etc/chef/cache',
        log_level: ::LOG_LEVEL).converge(described_recipe)
    end

    it 'creates user' do
      expect(chef_run).to create_user('flyway')
    end

    it 'creates group' do
      expect(chef_run).to_not create_group('flyway')
    end

    it 'creates directory' do
      expect(chef_run).to create_directory('/opt/flyway')
    end

    it 'downloads flyway cli' do
      expect(chef_run).to create_remote_file('/etc/chef/cache/flyway-commandline-3.2.1-linux-x64.tar.gz').with(
        source: 'https://bintray.com/artifact/download/business/maven/flyway-commandline-3.2.1-linux-x64.tar.gz'
      )
    end

    it 'notifies execute untar flyway' do
      resource = chef_run.remote_file('/etc/chef/cache/flyway-commandline-3.2.1-linux-x64.tar.gz')
      expect(resource).to notify('execute[extract flyway]').to(:run).immediately
    end

    it 'untars flyway cli' do
      resource = chef_run.execute('extract flyway')
      expect(resource).to do_nothing
    end
  end

  describe 'windows' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        platform: 'windows',
        version: '2012R2',
        file_cache_path: 'C:\chef\cache',
        log_level: ::LOG_LEVEL) do
        ENV['SYSTEMDRIVE'] = 'C:'
      end.converge(described_recipe)
    end

    it 'creates user' do
      expect(chef_run).to create_user('flyway')
    end

    it 'creates group' do
      expect(chef_run).to_not create_group('flyway')
    end

    it 'creates directory' do
      expect(chef_run).to create_directory('C:\flyway')
    end

    it 'downloads flyway cli' do
      expect(chef_run).to create_remote_file('C:\chef\cache/flyway-commandline-3.2.1-windows-x64.zip').with(
        source: 'https://bintray.com/artifact/download/business/maven/flyway-commandline-3.2.1-windows-x64.zip'
      )
    end

    it 'unzips flyway cli' do
      expect(chef_run).to_not run_batch('unzip flyway (powershell 3 or higher required)')
    end
  end
end
