directory '/tmp/db' do
  action :create
end

cookbook_file 'V001__schema.sql' do
  path '/tmp/db/V001__schema.sql'
  source "V001__schema.sql"
end

cookbook_file 'V002__data.sql' do
  path '/tmp/db/V002__data.sql'
  source "V002__data.sql"
end

include_recipe 'flywaydb::migrate'
