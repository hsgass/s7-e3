# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jcp/version"

Gem::Specification.new do |s|
  s.name        = "Java Class Parser"
  s.version     = JCP::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Steve Gass"]
  s.email       = ["hsgass@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Retrieves field and method information from a Java class file.}
  s.description = %q{}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features,.autotest,.rspec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec', '~>2.5.0'

end
