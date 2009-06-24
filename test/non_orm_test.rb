require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/../lib/modelfactory'

class ModelFactoryTest < Test::Unit::TestCase
  foo = Struct.new('Foo', :name)

  context "configured for a non-relational type" do
    setup do
      ModelFactory.configure do
        default(foo) { name { 'wubbo' } }
      end
    end
  
    should "apply config to a created instance" do
      assert_equal 'wubbo', ModelFactory[foo].create.name
    end

    should "apply config to a new instance" do
      assert_equal 'wubbo', ModelFactory[foo].new.name
    end
  end
end

