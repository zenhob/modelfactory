require 'active_support' # instance_exec

module ModelFactory # :nodoc:
  # This API allows you to instantiate models.
  class Factory # :nodoc:
    def initialize(klass, opt)
      @counter = 0
      @class = klass
      @options = opt || {}
    end

    def create(opt = {}, &block)
      create_named(:default, opt, &block)
    end

    def new(opt = {}, &block)
      new_named(:default, opt, &block)
    end

    def method_missing(method, opt = {}, &block)
      case method.to_s
      when /^create_(.+)$/
        create_named($1.to_sym, opt, &block)
      when /^new_(.+)$/
        new_named($1.to_sym, opt, &block)
      else
        raise NameError, "no such method `#{method}'"
      end
    end

   private

    def next_counter
      @counter += 1
    end

    def new_named(name, opt, &block)
      instance = @class.new
      InstanceBuilder.new(instance, opt, next_counter, &@options[name])
      instance
    end

    def create_named(name, opt, &block)
      instance = new_named(name, opt, &block)
      instance.save!
      instance.reload
      instance
    end

  end

  class InstanceBuilder # :nodoc:
    def initialize(instance, params, counter, &block)
      @instance = instance
      @params = params || {}
      @counter = counter
      @params.each { |attr, value| @instance.send "#{attr}=", value }
      instance_eval(&block) if block_given?
    end

    def method_missing(method, &block)
      if block_given? && !@params.key?(method.to_sym)
        @instance.send "#{method}=",
          (block.arity == 1) ?
            @instance.instance_exec(@counter, &block) :
            @instance.instance_eval(&block)
      end
    end
  end

end
