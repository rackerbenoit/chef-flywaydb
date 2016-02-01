flywaydb node['flywaydb']['name'] do
  conf node['flywaydb']['conf']
  action :validate
end
