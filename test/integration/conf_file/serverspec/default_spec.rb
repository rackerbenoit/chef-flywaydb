require 'serverspec_helper'

describe 'flyway::migrate' do
  if os[:family] == 'windows'
    describe file("C:/flywaydb/flyway/flyway.cmd") do
      it { should be_file }
      it { should be_owned_by 'flyway' }
    end

    describe command("type C:/flywaydb/flyway/conf/flyway_test.conf") do
      its(:stdout) { should_not match(/This file was generated by Chef/) }
      its(:stdout) { should match(%r{flyway.url=jdbc:mysql://localhost/mysql}) }
      its(:stdout) { should match(/flyway.schemas=flywaydb_test/) }
      its(:stdout) { should match(%r{flyway.locations=filesystem:/tmp/db}) }
    end
  else
    describe file('/opt/flywaydb/flyway/flyway.cmd') do
      it { should be_file }
      it { should be_owned_by 'flyway' }
    end

    describe command('cat /opt/flywaydb/flyway/conf/flyway.conf') do
      its(:stdout) { should_not match(/This file was generated by Chef/) }
      its(:stdout) { should match(%r{flyway.url=jdbc:mysql://localhost/mysql}) }
      its(:stdout) { should match(/flyway.schemas=flywaydb_test/) }
      its(:stdout) { should match(%r{flyway.locations=filesystem:/tmp/db}) }
    end
  end
end
