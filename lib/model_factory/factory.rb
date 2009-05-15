module ModelFactory
  # This API allows you to instantiate models.
  class Factory
    def initialize(klass, opt)
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

    def new_named(name, opt = {})
      instance = @class.new
      @options[name].call(instance) if @options[name]
      opt.each {|k,v| instance.send("#{k}=", v) }
      yield instance if block_given?
      instance
    end

    def create_named(name, opt = {}, &block)
      instance = new_named(name, opt, &block)
      instance.save!
      instance
    end

  end

end
