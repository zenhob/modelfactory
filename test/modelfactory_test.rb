require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/../lib/modelfactory'

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
  
  context "with a specified default" do
    setup do
      ModelFactory.configure do
        default(Widget) { name {'foobaz' } }
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

end


