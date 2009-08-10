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
  
  should "not raise on nil params" do
    assert_nothing_raised { Widget.factory.create(nil) }
  end

  should "permit use of overloaded names in configs" do
   assert_nothing_raised do
     ModelFactory.configure do
       inspect(Widget) { name {'foobaz' } }
       self.puts(Widget) { name {'fooboo' } }
     end
   end
   assert_equal Widget.factory.create_inspect.name, 'foobaz'
   assert_equal Widget.factory.create_puts.name, 'fooboo'
  end

  should "permit use of overloaded names in fields" do
   assert_nothing_raised do
     ModelFactory.configure do
       default(Widget) { self.puts {'shazbot' } }
     end
   end
   assert_equal Widget.factory.create.puts, 'shazbot'
  end

  should "use parent class options" do
   ModelFactory.configure do
     default(Widget) { name { 'shazbot' } }
   end
   assert_equal AnotherWidget.factory.create.name, 'shazbot'
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


