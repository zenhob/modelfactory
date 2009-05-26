require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/../lib/modelfactory'

class ModelFactoryTest < Test::Unit::TestCase
  context "with a specified default that uses automatic numbering" do
    setup do
      ModelFactory.configure do
        default(Widget) { price {|i| i } }
      end
    end
  
    should "start counting at 1 after configuration" do
      assert_equal 1.0, Widget.factory.create.price
    end

    should "generate a unique sequence" do
      w = []
      3.times { w << Widget.factory.create.price }
      assert_equal w.uniq, w
    end

  end
end


