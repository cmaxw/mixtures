require "rubygems"
require "bundler"
Bundler.setup

require File.dirname(__FILE__) + '/../../lib/mixtures'
require 'cucumber'
require 'spec'

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
  :host     => "localhost",
  :username => "root",
  :password => "",
  :database => "mixtures_test"
)

require File.dirname(__FILE__) + '/../../lib/mixtures/migrations'
Dir[File.dirname(__FILE__) + '/matchers/*.rb'].each {|file| require file }

# How to clean your database when transactions are turned off. See
# http://github.com/bmabey/database_cleaner for more info.
if defined?(ActiveRecord::Base)
  begin
    require 'database_cleaner'
    DatabaseCleaner.strategy = :truncation
  rescue LoadError => ignore_if_database_cleaner_not_present
  end
end
