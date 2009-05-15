require File.dirname(__FILE__) + '/test_helper'

ModelFactory.configure do
  default MFTest::Default, { :bar => 'baz' }
end

class ModelFactoryTest < Test::Unit::TestCase
  should "not create new records" do
    assert !MFTest::Default.factory.create(:baz => 4).new_record?
  end

  should "initialize defaults with no arguments" do
    assert_equal 'baz', MFTest::Default.factory.create.bar
  end

  should "initialize defaults with an unspecified argument" do
    assert_equal 'baz', MFTest::Default.factory.create(:baz => 4).bar
  end

  should "initialize with an unspecified argument" do
    assert_equal 4, MFTest::Default.factory.create(:baz => 4).baz
  end
end


