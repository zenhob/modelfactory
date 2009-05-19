require 'test/unit'
require 'rubygems'
require 'mocha'
require 'shoulda'

require File.dirname(__FILE__) + '/../lib/modelfactory'

require 'active_record'
ActiveRecord::Base.establish_connection(
  :database => ':memory:',
  :adapter  => 'sqlite3',
  :timeout  => 500
)

require 'active_record/fixtures'
require 'test/fixtures/schema.rb'
class Test::Unit::TestCase
  FIXTURES_PATH = File.join(File.dirname(__FILE__), '/fixtures')
  dep = defined?(ActiveSupport::Dependencies) ?
    ActiveSupport::Dependencies :
    ::Dependencies
  dep.load_paths.unshift FIXTURES_PATH
end

