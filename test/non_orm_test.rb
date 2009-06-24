require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/../lib/modelfactory'

class ModelFactoryTest < Test::Unit::TestCase
  class Foo < Struct.new('Foo', :name); end

  context "configured for a non-relational type" do
    setup do
      ModelFactory.configure do
        default(Foo) { name { 'wubbo' } }
      end
    end
  
    should "apply config to a created instance" do
      assert_equal 'wubbo', ModelFactory[Foo].create.name
    end

    should "apply config to a new instance" do
      assert_equal 'wubbo', ModelFactory[Foo].new.name
    end
  end
end

