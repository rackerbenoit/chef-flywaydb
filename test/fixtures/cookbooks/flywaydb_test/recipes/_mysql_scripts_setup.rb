flywaydb 'make sure flyway user and groups are created' do
  password node['flywaydb_test']['password']
  action :install
end

directory '/tmp/db' do
  action :create
end

cookbook_file 'V001__schema.sql' do
  path '/tmp/db/V001__schema.sql'
  source 'V001__schema.sql'
end

cookbook_file 'V002__data.sql' do
  path '/tmp/db/V002__data.sql'
  source 'V002__data.sql'
end

cookbook_file 'V003__user_grants.sql' do
  path '/tmp/db/V003__user_grants.sql'
  source 'V003__user_grants.sql'
end
