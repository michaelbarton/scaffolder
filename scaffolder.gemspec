# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{scaffolder}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Barton"]
  s.date = %q{2010-06-22}
  s.description = %q{Organise genome sequence data into scaffolds using YAML configuration files.}
  s.email = %q{mail@michaelbarton.me.uk}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/scaffolder.rb",
     "scaffolder.gemspec",
     "test/data/scaffold_order.yml",
     "test/data/sequences.fna",
     "test/helper.rb",
     "test/test_scaffolder.rb"
  ]
  s.homepage = %q{http://github.com/michaelbarton/scaffolder}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Scaffolder for genome sequence data}
  s.test_files = [
    "test/helper.rb",
     "test/test_scaffolder.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<redgreen>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<redgreen>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<redgreen>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end

