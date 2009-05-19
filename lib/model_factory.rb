#
# This is the legacy modelfactory API.
# The current implementation is in lib/modelfactory.rb.
#
require 'rubygems'
require 'active_record'
require 'modelfactory/legacy'

module ModelFactory
  def self.extended(mod)
    mod.extend(ModelFactory::Legacy)
  end
end
