flywaydb node['flywaydb']['name'] do
  conf node['flywaydb']['conf']
  action :baseline
end
