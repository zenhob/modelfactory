require 'rubygems'
require 'active_record'
require 'model_factory/legacy'

module ModelFactory

  # legacy API compatibility
  def self.extended(mod)
    mod.extend(ModelFactory::Legacy)
  end

end
