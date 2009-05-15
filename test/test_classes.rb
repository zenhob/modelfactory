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

