require File.dirname(__FILE__) + '/test_helper'

class ModelFactoryTest < Test::Unit::TestCase

  should "not instantiate when using new" do
    assert Widget.factory.new.new_record?
  end

  should "instantiate when using create" do
    assert !Widget.factory.create.new_record?
  end

  should "raise on creation of invalid records" do
    assert_raises(ActiveRecord::RecordInvalid) { StrictWidget.factory.create }
  end
  
  context "with a specified default that uses automatic numbering" do
    setup do
      ModelFactory.configure do
        default(Widget) {|w, i| w.price = i }
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

  context "with a specified default" do
    setup do
      ModelFactory.configure do
        default(Widget) {|w| w.name = 'foobaz' }
      end
    end
  
    should "initialize defaults with no arguments" do
      assert_equal 'foobaz', Widget.factory.create.name
    end
  
    should "initialize defaults with an unspecified argument" do
      assert_equal 'foobaz', Widget.factory.create(:price => 4.0).name
    end
  
    should "initialize with an unspecified argument" do
      assert_equal 4, Widget.factory.create(:price => 4.0).price
    end
  end

  context "with a named factory" do
    setup do
      ModelFactory.configure do
        default(Widget) {|w| w.name = 'wubbo' }
        favorite(Widget) {|w| w.name = 'foobaz' }
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


