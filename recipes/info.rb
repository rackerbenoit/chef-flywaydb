flywaydb node['flywaydb']['name'] do
  conf node['flywaydb']['conf']
  action :info
end
