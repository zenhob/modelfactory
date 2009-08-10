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
      # We might have a definition for a parent class. If so, use that.
      target = klass
      while target && !@config.class_opts.key?(target)
        target = target.superclass
      end
      @factory[klass] ||= Factory.new(klass, @config.class_opts[target])
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

    # Route common method names to method_missing.
    # XXX There must be a better way to do this, assuming we should be doing
    # this at all. BasicObject doesn't work because I lose instance_eval.
    [ :inspect, :send, :id, :object_id ].each do |meth|
      eval %{
        def #{meth}(*args, &block)
          method_missing(:#{meth}, *args, &block)
        end
      }
    end
  end
end
