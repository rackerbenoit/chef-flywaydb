require 'serverspec'

VERSION = '4.1.2'.freeze
MYSQL_VERSION = '5.1.41'.freeze

if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil?
  set :backend, :exec
else
  set :backend, :cmd
  set :os, family: 'windows'
end
