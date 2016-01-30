actions :migrate, :clean, :baseline, :info, :repair, :validate
default_action :migrate

attribute :name, kind_of: String, name_attribute: true
attribute :conf, kind_of: [Hash, Array], required: true
attribute :sensitive, kind_of: [TrueClass, FalseClass], default: lazy { node['flywaydb']['sensitive'] }
attribute :debug, kind_of: [TrueClass, FalseClass], default: lazy { node['flywaydb']['debug'] }
attribute :install_dir, kind_of: String, default: lazy { node['flywaydb']['install_dir'] }
attribute :user, kind_of: String, default: lazy { node['flywaydb']['user'] }
