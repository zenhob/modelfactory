require 'rubygems'
require 'active_record'
require 'model_factory/legacy'
require 'model_factory/factory'

module ModelFactory
  # configure the factory singleton by passing a block
  def self.configure(&block)
    @singleton = Factory.new(&block)
    ActiveRecord::Base.class_eval do
      def self.factory ; ModelFactory.factory.wrap(self) ; end
    end
  end

  def self.factory
    @singleton ||= Factory.new
  end

  # legacy API compatibility
  def self.extended(mod)
    mod.extend(ModelFactory::Legacy)
  end

end
