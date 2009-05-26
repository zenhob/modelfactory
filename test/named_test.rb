require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/../lib/modelfactory'

class ModelFactoryTest < Test::Unit::TestCase
  context "with a named factory" do
    setup do
      ModelFactory.configure do
        default(Widget) { name { 'wubbo' } }
        favorite(Widget) { name { 'foobaz' } }
      end
    end
  
    should "not apply named config to default" do
      assert_equal 'wubbo', Widget.factory.create.name
    end
  
    should "not apply any config to unrecognized name" do
      assert_equal nil, Widget.factory.create_emptyfoo.name
    end
  
    should "initialize defaults with no arguments" do
      assert_equal 'foobaz', Widget.factory.create_favorite.name
    end
  
    should "initialize defaults with an unspecified argument" do
      assert_equal 'foobaz', Widget.factory.create_favorite(:price => 4.0).name
    end
  
    should "initialize with an unspecified argument" do
      assert_equal 4, Widget.factory.create_favorite(:price => 4.0).price
    end
  end
end


