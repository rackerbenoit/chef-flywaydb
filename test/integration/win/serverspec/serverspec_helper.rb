require 'serverspec'

VERSION = '6.0.0-beta'.freeze
MYSQL_VERSION = '5.1.43'.freeze

if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
  set :backend, :exec
else
  set :backend, :cmd
  set :os, family: 'windows'
end
