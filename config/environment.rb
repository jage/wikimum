# frozen_string_literal: true

require 'sinatra/base'
require 'sequel'

if ENV.fetch('RACK_ENV') == 'development'
  ENV['SESSION_SECRET'] ||= 'secret'

  $stdout.sync = true
  $stderr.sync = true
end

DB = Sequel.connect(ENV.fetch('DATABASE_URL'))

if ENV.fetch('RACK_ENV') == 'development'
  require 'logger'
  DB.logger = Logger.new($stdout)

  # Enable warnings, but not for gems
  require 'tool/warning_filter'
end

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'services'
require 'models'
require 'controllers'
