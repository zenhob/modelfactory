= ModelFactory

ModelFactory is a module designed to replace the use of fixtures for testing
Rails applications.

The idea is that instead of keeping your test data in a nearly opaque fixture
file, you generate data in the test itself using a custom factory API designed
for your test environment.

By creating a new module just for your test factory API you make it easier
to spot factory calls in your tests and keep your factory code out of your
test code. ModelFactory adds some useful facilities for generating optional
defaults for commonly instantiated types. It also fakes up id generation in
the ActiveRecord models created with new, to assist in unit testing without
the database.

=== A Note About Defaults

When writing tests that use factory-generated objects, it's important never
to depend on default values in your test assertions. If you depend on defaults
in your tests they become more fragile and the intention is harder to discern.

If you find yourself repeating the same initialization to avoid using defaults,
consider whether it would be appropriate to add a custom toplevel method to
your factory module that includes this initialization.

=== A Note About ID Generation

Since basic ID generation is done when you instantiate objects using
Factory.new_<type> it is recommended not to mix such objects with those
created using Factory.create_<type>. Use the former in unit tests and
use the latter in functional tests.

== Using ModelFactory

Put something like this in your test helper:

 module Factory
   extend ModelFactory

   # a default block accepts a class and a hash of default values
   default Color, {
     :name => 'chartreuse'
   }

   default User, {
     :first_name => 'Harry',
     :last_name => 'Manchester',
     :favorite_color => default_color
   }

   # Add class methods to create whatever kind of objects you need for your tests
   def self.new_user_with_colorblindness
     new_user { :favorite_color => nil }
   end

 end

Then in your tests you use Factory methods to instantiate your test objects:

 # For most functional tests you can use create.
 def test_something
   user = Factory.create_user
   user.friends << Factory.create_user(:first_name => 'Frank')
   assert user.likes_frank?
 end

 # For unit tests you use new.
 def test_something_else
   user = Factory.new_user(:favorite_color => Factory.new_color(:name => 'blue'))
   assert user.likes_blue?
 end

 # Assertions should not depend on default data, but it can be useful to create
 # factory methods that build objects with specific traits.
 def test_yet_something_else
   user = Factory.new_user_with_colorblindness
   assert !user.likes_blue?
 end

== Installing ModelFactory

 sudo gem install model_factory

== License

Copyright (c) 2008 Justin Balthrop and Zack Hobson
Published under The MIT License, see License.txt

