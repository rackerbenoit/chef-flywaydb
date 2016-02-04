flywaydb node['flywaydb']['name'] do
  conf node['flywaydb']['conf']
  ext_conf node['flywaydb']['ext_conf']
  params node['flywaydb']['params']
  debug node['flywaydb']['debug']
  sensitive node['flywaydb']['sensitive']
  action :info
end
