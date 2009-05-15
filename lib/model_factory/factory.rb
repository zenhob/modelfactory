module ModelFactory
  # This API allows you to instantiate models.
  class Factory
    def initialize(klass, opt)
      @class = klass
      @options = opt || {}
    end

    def create(opt = {}, &block)
      instance = new(opt, &block)
      instance.save!
      instance
    end

    def new(opt = {})
      instance = @class.new
      @options[:default].call(instance) if @options[:default]
      opt.each {|k,v| instance.send("#{k}=", v) }
      instance
    end
  end


end
