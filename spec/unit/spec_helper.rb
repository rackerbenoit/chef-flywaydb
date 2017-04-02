# Encoding: utf-8

require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start!

::LOG_LEVEL = :error

::CHEFSPEC_OPTS = {
  log_level: ::LOG_LEVEL
}.freeze

VERSION = '4.1.2'.freeze
