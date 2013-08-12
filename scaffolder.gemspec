# -*- encoding: utf-8 -*-
require File.expand_path("../lib/scaffolder/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "scaffolder"
  s.version     = VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michael Barton"]
  s.email       = %q{mail@next.gs}
  s.homepage    = "http://next.gs"
  s.summary     = %Q{Build genome output files}
  s.description = %Q{Turns scaffolded contigs and annotations into a genome.}
  s.license     = "MIT"

  s.required_rubygems_version = ">= 1.8.0"
  s.rubyforge_project         = "scaffolder"

  s.add_dependency "rake"   , "~> 10.1.0"
  s.add_dependency "bundler", "~> 1.3.0"
  s.add_dependency "bio",     "~> 1.4.0"

  # Specs
  s.add_development_dependency "shoulda", "~> 3.5.0"
  s.add_development_dependency "rspec",   "~> 2.14.0"
  s.add_development_dependency "mocha",   "~> 0.14.0"
  s.add_development_dependency "yard",    "~> 0.8.0"
  
  # Features
  s.add_development_dependency "cucumber", "~> 1.3.0"
  s.add_development_dependency "aruba",    "~> 0.5.3"

  s.files        = `git ls-files`.split("\n")
  s.require_path = 'lib'
end
