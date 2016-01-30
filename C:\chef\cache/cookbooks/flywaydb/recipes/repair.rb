flywaydb 'flyway' do
  conf node['flywaydb']['conf']
  debug node['flywaydb']['debug']
  sensitive node['flywaydb']['sensitive']
  action :repair
end
