require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/../lib/modelfactory'

class ModelFactoryTest < Test::Unit::TestCase
  context "initializing a belongs_to relation" do
    setup do
      ModelFactory.configure do
        default(Category) do
          name { "Factory Category" }
        end
        default(Widget) do
          category { Category.factory.create }
        end
      end
    end

    should "automatically create parent instance" do
      old_count = Category.count
      assert !Widget.factory.create.category.nil?
      assert_equal old_count + 1, Category.count
    end

    should "do not create a parent when one is passed in" do
      old_count = Category.count
      Widget.factory.create(:category => nil)
      assert_equal old_count, Category.count
    end

    should "do not assign a parent when nil is passed in" do
      assert Widget.factory.create(:category => nil).category.nil?
    end
  end
end
  
