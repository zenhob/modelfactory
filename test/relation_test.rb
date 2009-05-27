require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/../lib/modelfactory'

class ModelFactoryTest < Test::Unit::TestCase
  context "default refers to previously initialized value" do
    setup do
      ModelFactory.configure do
        default(Category) do
          name { "Factory Category" }
        end
        default(Widget) do
          category { Category.factory.create }
          name { "#{category.name} Widget" }
        end
      end
    end

    should "refer to fields initialized by default block" do
      assert_equal "Factory Category Widget", Widget.factory.create.name
    end

    should "refer to fields initialized on create" do
      cat = Category.create(:name => 'Foobar')
      assert_equal "Foobar Widget", Widget.factory.create(:category => cat).name
    end
  end

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
  
