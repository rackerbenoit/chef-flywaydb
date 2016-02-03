flywaydb node['flywaydb']['name'] do
  params node['flywaydb']['params']
  conf node['flywaydb']['conf']
  debug node['flywaydb']['debug']
  sensitive node['flywaydb']['sensitive']
  action :migrate
end
