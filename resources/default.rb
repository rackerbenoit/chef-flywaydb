actions :migrate, :clean, :baseline, :info, :repair, :validate
default_action :migrate

attribute :name, kind_of: String, name_attribute: true
attribute :ext_conf, kind_of: [String, Array, NilClass], default: nil
attribute :conf, kind_of: [Hash, Array, NilClass], default: nil
attribute :params, kind_of: Hash, default: {}
attribute :sensitive, kind_of: [TrueClass, FalseClass], default: false
attribute :debug, kind_of: [TrueClass, FalseClass], default: true
attribute :install_dir, kind_of: String, default: lazy { node['flywaydb']['install_dir'] }
attribute :user, kind_of: String, default: lazy { node['flywaydb']['user'] }
attribute :group, kind_of: String, default: lazy { node['flywaydb']['group'] }
