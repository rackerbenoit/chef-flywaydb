actions :migrate, :clean, :baseline, :info, :repair, :validate
default_action :migrate

attribute :name, kind_of: String, name_attribute: true
attribute :conf, kind_of: [Hash, Array], required: true
attribute :params, kind_of: Hash, default: lazy { node['flywaydb']['params'] }
attribute :sensitive, kind_of: [TrueClass, FalseClass], default: lazy { node['flywaydb']['sensitive'] }
attribute :quiet, kind_of: [TrueClass, FalseClass], default: lazy { node['flywaydb']['quiet'] }
attribute :debug, kind_of: [TrueClass, FalseClass], default: lazy { node['flywaydb']['debug'] }
attribute :install_dir, kind_of: String, default: lazy { node['flywaydb']['install_dir'] }
attribute :user, kind_of: String, default: lazy { node['flywaydb']['user'] }
attribute :group, kind_of: String, default: lazy { node['flywaydb']['group'] }
