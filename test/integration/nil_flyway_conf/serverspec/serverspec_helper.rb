require 'serverspec'

VERSION = '4.1.0'.freeze
MARIADB_VERSION = '5.1.40'.freeze

if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
  set :backend, :exec
else
  set :backend, :cmd
  set :os, family: 'windows'
end
