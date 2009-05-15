= ModelFactory

ModelFactory is a module designed to replace the use of fixtures for testing
Rails applications.

The best explanation for the motivation behind ModelFactory (and the inspiration
for this module) comes from Dan Manges' blog: http://www.dcmanges.com/blog/38

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

The purpose of default values is to generate valid instances, not to serve as
replacements for fixture data. When writing tests that use factory-generated
objects, it's important never to depend on default values in your test assertions.
If you depend on defaults in your tests they become more fragile and the intention
is harder to discern. Alway override values you care about when using factory objects.

If you find yourself repeating the same initialization to avoid using defaults,
consider whether it would be appropriate to add a custom toplevel method to
your factory module that includes this initialization. You can also specify
multiple named types of defaults, described below. Be aware that both of these
techniques should be used sparingly, as they can have some of the same issues
as fixtures.

=== A Note About ID Generation

Since basic ID generation is done when you instantiate objects using
Factory.new_<type> it is recommended not to mix such objects with those
created using Factory.create_<type>. Use the former in unit tests and
use the latter in functional tests.

== Installing ModelFactory

 sudo gem install modelfactory

== License

Copyright (c) 2008 Justin Balthrop and Zack Hobson
Published under The MIT License, see License.txt

