= ModelFactory

ModelFactory is a module designed to replace the use of fixtures for testing
Rails applications.

The best explanation for the motivation behind ModelFactory (and the inspiration
for this module) comes from Dan Manges' blog: http://www.dcmanges.com/blog/38

NOTE that the API has changed recently, but ModelFactory is still fully
backward-compatible with previous releases. For a description of the original
API see ModelFactory::Legacy.

== Usage

The essential purpose of ModelFactory is the automatic generation of valid,
opaque ActiveRecord objects whose contents are unimportant.

 require 'modelfactory'

 ModelFactory.configuration do
   default(User) do |m|
     m.name = "Factory User"
     m.email = "user@factory.ws"
   end
 end

 ModelFactory[User].create.name  # => 'Factory User'

If you don't care for the factory creation syntax, ModelFactory defines the
factory class method on ActiveRecord models. The following is equivalent
to ModelFactory[User].create:

 User.factory.create

Since factory-created instances are meant to be valid, you will probably
need a way to generate unique values. ModelFactory keeps a counter for each
type that increments when each new instance is created. This counter is passed
to configuration blocks to make it easier to generate unique values:

 ModelFactory.configuration do
   default(User) do |m, i|
     m.name = "Factory User #{i}"
     m.email = "user#{i}@factory.ws"
   end
 end

 User.factory.create.name  # => 'Factory User 1'
 User.factory.create.email # => 'user2@factory.ws'

Defaults can be overriden on instance creation. By not specifying unimportant
values, the intention of your tests becomes clearer:

 def test_welcome
    user = ModelFactory[User].create(:name => 'bob')
    assert_equal 'Welcome, bob!', user.welcome
 end

It's possible to configure named factories:

 ModelFactory.configuration do
   admin(User) do |m, i|
     m.name = "Admin User #{i}"
     m.admin = true
   end
 end

 User.factory.create_admin.admin  # => true

Named factories do not inherit anything from the default, so you'll still need to
provide enough to data to allow the creation of valid objects.

=== A Note About Defaults

The purpose of default values is to generate valid instances, not to serve as
replacements for fixture data. When writing tests that use factory-generated
objects, it's important never to depend on default values in your test assertions.
If you depend on defaults in your tests they become more fragile and the intention
is harder to discern. Alway override values you care about when using factory objects.

== Installing ModelFactory

 sudo gem install modelfactory

== License

Copyright (c) 2008, 2009 Justin Balthrop and Zack Hobson

Published under The MIT License, see License.txt

