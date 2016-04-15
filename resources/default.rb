actions :migrate, :clean, :baseline, :info, :repair, :validate
default_action :migrate

attribute :name, kind_of: String, name_attribute: true
attribute :flyway_conf, kind_of: [String, Hash, NilClass], default: nil
attribute :alt_conf, kind_of: [String, Hash, Array, NilClass], default: nil
attribute :params, kind_of: Hash, default: {}
attribute :debug, kind_of: [TrueClass, FalseClass], default: false
attribute :install_dir, kind_of: String, default: lazy { node['flywaydb']['install_dir'] }
attribute :user, kind_of: String, default: lazy { node['flywaydb']['user'] }
attribute :group, kind_of: String, default: lazy { node['flywaydb']['group'] }

attribute :sensitive, kind_of: [TrueClass, FalseClass] # , default: true - see initialize below

# Chef will override sensitive back to its global value, so set default to true in init
def initialize(*args)
  super
  @sensitive = true
end
