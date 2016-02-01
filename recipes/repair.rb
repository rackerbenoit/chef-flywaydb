flywaydb node['flywaydb']['name'] do
  params node['flywaydb']['params']
  conf node['flywaydb']['conf']
  debug node['flywaydb']['debug']
  quiet node['flywaydb']['quiet']
  sensitive node['flywaydb']['sensitive']
  action :repair
end
