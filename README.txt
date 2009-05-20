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

Defaults can be overriden on instance creation. By not specifying unimportant
values, the intention of your tests becomes clearer:

 def test_welcome
    user = ModelFactory[User].create(:name => 'bob')
    assert_equal 'Welcome, bob!', user.welcome
 end

If you don't care for the factory creation syntax, ModelFactory defines the
factory class method on ActiveRecord models. The following is equivalent
to ModelFactory[User].create:

 User.factory.create

When you use a factory to create an instance, the save! and reload methods are
called before the instance is returned. This means instances must be valid after
being initialized by the factory, or an ActiveRecord validation error will be
raised.

 class Widget < ActiveRecord::Base
   validates_presence_of :name, :desc
 end

 ModelFactory.configure do
   default(Widget) {|w| w.name = 'widget' }
 end

 # Raises an error because no desc was provided:
 Widget.factory.create

 # Doesn't raise, a desc is provided:
 Widget.factory.create(:desc => 'widget desc')

 # Doesn't raise, required values are defined in the default factory:
 ModelFactory.configure do
   default(Widget) {|w| w.name = 'widget'; w.desc = 'widget desc' }
 end
 Widget.factory.create

Since creating valid objects usually means having unique values, ModelFactory
keeps a counter for each type that increments when each new instance is
created. This counter is passed to model initialization blocks to make it
easier to generate unique values:

 ModelFactory.configuration do
   default(User) do |m, i|
     m.name = "Factory User #{i}"
     m.email = "user#{i}@factory.ws"
   end
 end

 User.factory.create.name  # => 'Factory User 1'
 User.factory.create.email # => 'user2@factory.ws'

It's possible to configure named factories:

 ModelFactory.configuration do
   admin(User) do |m, i|
     m.name = "Admin User #{i}"
     m.admin = true
   end
 end

 User.factory.create_admin.admin  # => true

Named factories do not inherit anything from the default, so you'll still need to
provide enough data to allow the creation of valid objects.

== Installing ModelFactory

 sudo gem install modelfactory

== License

Copyright (c) 2008, 2009 Justin Balthrop and Zack Hobson

Published under The MIT License, see License.txt

