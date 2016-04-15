# Note that this is for testing purposes and it is not a good idea
# to pass sensitive information in recipe attributes
default['flywaydb_test']['flyway_conf'] = nil
default['flywaydb_test']['alt_conf'] = nil
default['flywaydb_test']['params'] = {}
default['flywaydb_test']['debug'] = false
default['flywaydb_test']['sensitive'] = true

default['flywaydb_test']['mysql']['version'] = '5.6'
