require File.dirname(__FILE__) + '/test_helper'

# The classes below are rough mocks of ActiveRecord::Base that only handle instantiation.

# This class has defaults defined.
class ModelFactoryTestDef
  def self.protected_attributes;  nil; end
  def self.accessible_attributes; nil; end
  
  attr_accessor :id, :nest, :bar, :baz
  def initialize(opts = {})
    opts.each do |k,v|
      self.send("#{k}=", v)
    end
  end
end

# This class has no defaults defined.
class ModelFactoryTestNoDef < ModelFactoryTestDef; end

# This class has nested defaults defined.
class ModelFactoryTestNestDef < ModelFactoryTestDef; end

# This class has protected attributes.
class ModelFactoryTestProtected < ModelFactoryTestDef
  def self.protected_attributes; [:baz]; end

  def initialize(opts = {})
    opts = opts.clone
    opts.delete(:baz) # Simulate a protected attribute.
    super(opts)
  end
end

# This class has accessible attributes.
class ModelFactoryTestAccessible < ModelFactoryTestDef
  def self.accessible_attributes; [:id, :nest, 'bar']; end

  def initialize(opts = {})
    opts = opts.clone
    opts.delete(:baz) # Simulate a protected attribute.
    super(opts)
  end
end

# This is the testfactory class def with test defaults.
class ModelFactoryTestFactory
  extend ModelFactory
  default ModelFactoryTestDef, { :bar => 'baz' }
  default ModelFactoryTestNestDef, { :nest => default_model_factory_test_def }
end

class ModelFactoryTest < Test::Unit::TestCase
  should "initialize protected attributes" do
    m = ModelFactoryTestFactory.new_model_factory_test_protected(:baz => 4)
    assert_equal 4, m.baz
  end
  
  should "initialize dynamic protected attributes" do
    i = 1
    m = ModelFactoryTestFactory.new_model_factory_test_protected(:bar => 3, :baz => lambda { i += 1 } )
    assert_equal 2, m.baz
  end

  should "initialize accessible attributes" do
    m = ModelFactoryTestFactory.new_model_factory_test_accessible(:baz => 4)
    assert_equal 4, m.baz
  end
  
  should "initialize dynamic accessible attributes" do
    i = 1
    m = ModelFactoryTestFactory.new_model_factory_test_accessible(:bar => 3, :baz => lambda { i += 1 } )
    assert_equal 2, m.baz
  end

  should "initialize with no arguments and nested defaults" do
    m = ModelFactoryTestFactory.new_model_factory_test_nest_def
    assert m.nest.id > 0
    assert m.id > 0
  end

  should "intialize with arguments and nested defaults" do
    m = ModelFactoryTestFactory.new_model_factory_test_nest_def(:bar => 'foo')
    assert_equal 'foo', m.bar
    assert m.nest.id > 0
    assert m.id > 0
  end

  should "intialize with no arguments and explicit defaults" do
    m = ModelFactoryTestFactory.new_model_factory_test_def
    assert_equal 'baz', m.bar
    assert m.id > 0
  end

  should "intialize with arguments and explicit defaults" do
    m = ModelFactoryTestFactory.new_model_factory_test_def(:bar => 'foo')
    assert_equal 'foo', m.bar
    assert m.id > 0
  end

  should "create with arguments and explicit defaults" do
    instance = ModelFactoryTestDef.new
    ModelFactoryTestDef.expects(:create!).with(:bar => 'foo').returns(instance)
    ModelFactoryTestFactory.create_model_factory_test_def(:bar => 'foo')
  end

  should "create with no arguments and explicit defaults" do
    instance = ModelFactoryTestDef.new
    ModelFactoryTestDef.expects(:create!).with(:bar => 'baz').returns(instance)
    ModelFactoryTestFactory.create_model_factory_test_def
  end

  should "initialize with no arguments and no defaults" do
    instance = ModelFactoryTestNoDef.new
    ModelFactoryTestNoDef.expects(:new).returns(instance)
    m = ModelFactoryTestFactory.new_model_factory_test_no_def
    assert m.id > 0
  end

  should "initialize with arguments and no defaults" do
    instance = ModelFactoryTestNoDef.new
    ModelFactoryTestNoDef.expects(:new).with(:bar => 'foo').returns(instance)
    m = ModelFactoryTestFactory.new_model_factory_test_no_def(:bar => 'foo')
    assert m.id > 0
  end

  should "create with no arguments and no defaults" do
    instance = ModelFactoryTestNoDef.new
    ModelFactoryTestNoDef.expects(:create!).returns(instance)
    ModelFactoryTestFactory.create_model_factory_test_no_def
  end

  should "create with arguments and no defaults" do
    instance = ModelFactoryTestNoDef.new
    ModelFactoryTestNoDef.expects(:create!).with(:bar => 'foo').returns(instance)
    ModelFactoryTestFactory.create_model_factory_test_no_def(:bar => 'foo')
  end
end

