require 'rubygems'
require 'hoe'
$:.unshift(File.dirname(__FILE__) + "/lib")
require 'modelfactory/version'

Hoe.new('ModelFactory', ModelFactory::VERSION::STRING) do |p|
  p.name = "modelfactory"
  p.author = ['Justin Balthrop', 'Zack Hobson']
  p.description = "A replacement for fixtures."
  p.email = "justin@geni.com"
  p.summary = "A replacement for fixtures."
  p.url = "http://modelfactory.rubyforge.org/"
  p.rubyforge_name = 'modelfactory'
  p.remote_rdoc_dir = '' # Release to root
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.test_globs = ["test/**/*_test.rb"]
  p.clean_globs |= ['**/.*.sw?', '*.gem', '.config', '**/.DS_Store']
  p.extra_dev_deps = ['active_record', 'mocha', 'thoughtbot-shoulda', 'sqlite3-ruby']
end


