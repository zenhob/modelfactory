require 'rubygems'
require 'active_record'
require File.dirname(__FILE__) + '/modelfactory/factory'
require File.dirname(__FILE__) + '/modelfactory/legacy'

ActiveRecord::Base.class_eval do
  def self.factory ; ModelFactory[self] ; end
end

module ModelFactory
  # Configure the factory singleton by passing a block.
  #
  # You can call this method multiple times. Each time you do so it will
  # clear the existing configuration and reset the counters.
  #
  # You don't need to configure ModelFactory to use it.
  def self.configure(&block)
    @singleton = Wrapper.new(&block)
  end

  # Get the Factory for a given model class.
  def self.[](klass)
    @singleton ||= Wrapper.new
    @singleton.wrap(klass)
  end

  # Enable legacy API compatibility.
  def self.extended(mod) # :nodoc:
    mod.extend(ModelFactory::Legacy)
  end

  # Singleton Factory wrapper class.
  class Wrapper # :nodoc:
    # Create a new FactoryConfiguration with the given block.
    def initialize(&block)
      @config = FactoryConfiguration.new(&block)
      @factory = {}
    end

    # Wraps a given class in a configured Factory instance.
    def wrap(klass)
      @factory[klass] ||= Factory.new(klass, @config.class_opts[klass])
    end
  end

  # Factory configuration class.
  class FactoryConfiguration # :nodoc:
    attr_reader :class_opts

    def initialize(&block)
      @class_opts = {}
      instance_eval(&block) if block_given?
    end

    # All method calls set up a configuration named after the method.
    def method_missing(method, klass, &block)
      @class_opts[klass] ||= {}
      @class_opts[klass][method] = block
    end
  end
end
