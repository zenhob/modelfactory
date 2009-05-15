module ModelFactory
  class Factory
    def initialize(&block)
      @config = FactoryConfiguration.new(&block)
    end

    def wrap(klass)
      FactoryWrapper.new(klass, @config.class_opts[klass])
    end
  end

  class FactoryConfiguration
    attr_reader :class_opts

    def initialize(&block)
      @class_opts = {}
      instance_eval &block
    end

    def default(klass, opts)
      @class_opts[klass] = opts
    end
  end

  class FactoryWrapper
    def initialize(klass, opt = nil)
      @class = klass
      @options = opt || {}
    end

    def create(opt = {})
      @class.create! opt.merge(@options)
    end
  end
end
