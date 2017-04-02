actions :migrate, :clean, :baseline, :info, :repair, :validate, :install
default_action :migrate

attribute :name, kind_of: String, name_attribute: true
attribute :flyway_conf, kind_of: [String, Hash, NilClass], default: nil
attribute :alt_conf, kind_of: [String, Hash, Array, NilClass], default: nil
attribute :parameters, kind_of: Hash, default: {}
attribute :mysql_driver, kind_of: [TrueClass, FalseClass], default: false
attribute :debug, kind_of: [TrueClass, FalseClass], default: false
attribute :install_dir, kind_of: String, default: lazy { node['flywaydb']['install_dir'] }
attribute :user, kind_of: String, default: lazy { node['flywaydb']['user'] }
attribute :password, kind_of: [String, NilClass], default: nil
attribute :group, kind_of: String, default: lazy { node['flywaydb']['group'] }
attribute :timeout, kind_of: Integer, default: lazy { node['flywaydb']['timeout'] }

attribute :sensitive, kind_of: [TrueClass, FalseClass] # , default: true - see initialize below

# Chef will override sensitive back to its global value, so set default to true in init
def initialize(*args)
  super
  @sensitive = true
end
