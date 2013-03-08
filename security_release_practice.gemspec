# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'security_release_practice/version'

Gem::Specification.new do |spec|
  spec.name          = "security_release_practice"
  spec.version       = SecurityReleasePractice::VERSION
  spec.authors       = ["Steve Klabnik"]
  spec.email         = ["steve@steveklabnik.com"]
  spec.description   = %q{Practice creating a security release.}
  spec.summary       = %q{Practice creating a security release.}
  spec.homepage      = "https://github.com/steveklabnik/security_release_practice"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
