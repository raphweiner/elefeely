# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elefeely/version'

Gem::Specification.new do |spec|
  spec.name          = "elefeely"
  spec.version       = Elefeely::VERSION
  spec.authors       = ["Raphael Weiner"]
  spec.email         = ["raphael.weiner@gmail.com"]
  spec.description   = %q{Elefeely remembers your feelings}
  spec.summary       = %q{Elefeely is your ruby interface to your feelings}
  spec.homepage      = "http://github.com/raphael/elefeely"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
