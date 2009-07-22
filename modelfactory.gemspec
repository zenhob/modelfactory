# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{modelfactory}
  s.version = "0.9.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Justin Balthrop", "Zack Hobson"]
  s.date = %q{2009-07-22}
  s.description = %q{A replacement for fixtures.}
  s.email = %q{justin@geni.com}
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "License.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/model_factory.rb", "lib/modelfactory.rb", "lib/modelfactory/factory.rb", "lib/modelfactory/legacy.rb", "lib/modelfactory/version.rb", "script/destroy", "script/generate", "script/txt2html", "setup.rb", "test/counter_test.rb", "test/fixtures/category.rb", "test/fixtures/schema.rb", "test/fixtures/strict_widget.rb", "test/fixtures/widget.rb", "test/legacy_test.rb", "test/modelfactory_test.rb", "test/named_test.rb", "test/relation_test.rb", "test/test_helper.rb", "test/non_orm_test.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://modelfactory.rubyforge.org/}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{modelfactory}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A replacement for fixtures.}
  s.test_files = ["test/counter_test.rb", "test/modelfactory_test.rb", "test/relation_test.rb", "test/non_orm_test.rb", "test/legacy_test.rb", "test/named_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<activerecord>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_development_dependency(%q<sqlite3-ruby>, [">= 0"])
      s.add_development_dependency(%q<mislav-hanna>, [">= 0"])
      s.add_development_dependency(%q<hoe>, [">= 2.3.1"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
      s.add_dependency(%q<mislav-hanna>, [">= 0"])
      s.add_dependency(%q<hoe>, [">= 2.3.1"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
    s.add_dependency(%q<mislav-hanna>, [">= 0"])
    s.add_dependency(%q<hoe>, [">= 2.3.1"])
  end
end
