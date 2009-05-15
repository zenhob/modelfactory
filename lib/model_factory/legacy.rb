module ModelFactory
  # == ModelFactory Legacy API
  # 
  # Put something like this in your test helper:
  # 
  #  require 'model_factory'
  # 
  #  module Factory
  #    extend ModelFactory
  # 
  #    # a default block accepts a class and a hash of default values
  #    default Color, {
  #      :name => 'chartreuse'
  #    }
  # 
  #    default User, {
  #      :first_name => 'Harry',
  #      :last_name => 'Manchester',
  #      :favorite_color => default_color
  #    }
  # 
  #    # Add class methods to create whatever kind of objects you need for your tests
  #    def self.new_user_with_colorblindness
  #      new_user { :favorite_color => nil }
  #    end
  # 
  #  end
  # 
  # Then in your tests you use Factory methods to instantiate your test objects:
  # 
  #  # For most functional tests you can use create.
  #  def test_something
  #    user = Factory.create_user
  #    user.friends << Factory.create_user(:first_name => 'Frank')
  #    assert user.likes_frank?
  #  end
  # 
  #  # For unit tests you use new.
  #  def test_something_else
  #    user = Factory.new_user(:favorite_color => Factory.new_color(:name => 'blue'))
  #    assert user.likes_blue?
  #  end
  # 
  #  # Assertions should not depend on default data, but it can be useful to create
  #  # factory methods that build objects with specific traits.
  #  def test_yet_something_else
  #    user = Factory.new_user_with_colorblindness
  #    assert !user.likes_blue?
  #  end
  # 
  # You can also specify types of models in your calls to defaults, but be careful. This can
  # easily start to become a lot like fixtures:
  # 
  #  module Factory
  #    extend ModelFactory
  # 
  #    default User, :joined {
  #      :first_name => 'Harry',
  #      :last_name => 'Manchester',
  #      :joined => true,
  #      :set_password => true,
  #    }
  #   
  #    default User, :unjoined {
  #      :first_name => 'Harry',
  #      :last_name => 'Manchester',
  #      :joined => false,
  #      :set_password => false,
  #    }
  #  end
  # 
  # Then in your test:
  # 
  #  def test_something
  #    user1 = Factory.create_joined_user(:first_name => 'Bill')
  #    user2 = Factory.create_unjoined_user(:first_name => 'Sandy')
  #    assert  user1.joined?
  #    assert !user2.joined?
  #  end
  # 
  module Legacy
    def next_local_id # :nodoc:
      @max_id ||= 0
      return @max_id += 1
    end

    #
    # When specifying defaults, you should only provide only enough data that
    # the created instance is valid. If you want to include another factory
    # object as a dependency use the special method default_* instead of
    # create_* or new_*.
    #
    def default(class_type, *default_args)
      defaults   = default_args.pop || {}
      prefix     = default_args.first
      class_name = class_type.name.demodulize.underscore
      class_name = "#{prefix}_#{class_name}" if prefix

      (class << self; self; end).module_eval do
        define_method "create_#{class_name}" do |*args|
          attributes = args.first || {}
          create_instance(class_type, attributes, defaults)
        end
      
        define_method "new_#{class_name}" do |*args|
          attributes = args.first || {}
          new_instance(class_type, attributes, defaults)
        end

        define_method "default_#{class_name}" do |*args|
          attributes = args.first || {}
          default_closure(class_type, attributes, defaults)
        end
      end
    end
      
    def create_instance(class_type, attributes, defaults = {}) # :nodoc:
      attributes = instantiate_defaults(:create, defaults.merge(attributes))
      instance = class_type.create!(attributes)
      if update_protected_attributes(instance, attributes)
        instance.save
      end
      instance
    end
    
    def new_instance(class_type, attributes, defaults = {}) # :nodoc:
      attributes = instantiate_defaults(:new, defaults.merge(attributes))
      instance = class_type.new(attributes)
      instance.id = next_local_id
      update_protected_attributes(instance, attributes)
      instance
    end

    def default_closure(class_type, attributes, defaults = {}) # :nodoc:
      lambda do |create_or_new|
        case create_or_new
        when :new    ; new_instance(class_type, attributes, defaults)
        when :create ; create_instance(class_type, attributes, defaults)
        end
      end
    end
    
    def instantiate_defaults(create_or_new, attributes) # :nodoc:
      attributes.each do |key, value|
        if value.is_a?(Proc)
          attributes[key] = value.arity == 0 ? value.call : value.call(create_or_new)
        end
      end
      attributes
    end

    def update_protected_attributes(instance, attributes) # :nodoc:
      modified = false
      protected_attrs  = instance.class.protected_attributes
      protected_attrs  = protected_attrs.to_set if protected_attrs
      accessible_attrs = instance.class.accessible_attributes
      accessible_attrs = accessible_attrs.to_set if accessible_attrs

      if protected_attrs or accessible_attrs
        attributes.each do |key, value|
          # Support symbols and strings.
          next if protected_attrs  and (not protected_attrs.include?(key) or protected_attrs.include?(key.to_s))
          next if accessible_attrs and (accessible_attrs.include?(key) or accessible_attrs.include?(key.to_s))
          modified = true
          instance.send("#{key}=", value)
        end
      end
      return modified
    end

    # Any class methods of the form "new_some_type(attrs)" or "create_some_type(attrs)" will be converted to
    # "SomeType.new(attrs)" and "SomeType.create!(attrs)" respectively.
    # These basically function as though you'd used the 'default' directive with empty defaults.
    def method_missing(missing_method, attributes = {})
      if missing_method.to_s.match(/^(new|create|default)_([a-z][\w_]+)$/)
        method, class_name = $1, $2
        class_type = class_name.camelize.constantize
        case method
        when 'create'
          create_instance(class_type, attributes)
        when 'new'
          new_instance(class_type, attributes)
        when 'default'
          default_closure(class_type, attributes)
        end
      else
        raise NoMethodError, "no such method '#{missing_method}'"
      end
    end
  end
end
