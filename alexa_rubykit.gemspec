# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alexa_rubykit/version'

Gem::Specification.new do |spec|
  spec.name          = "alexa_rubykit"
  spec.version       = AlexaRubykit::VERSION
  spec.authors       = ["Damian Finol"]
  spec.email         = ["damian.finol@gmail.com"]
  spec.summary       = %q{Alexa Ruby Kit}
  spec.description   = %q{Alexa Ruby Kit with examples}
  spec.homepage      = ""
  spec.license       = "MIT"
  spec.files         = Dir['[A-Z]*'] + Dir['lib/**/*'] + Dir['tests/**'] + Dir['bin/**']
  spec.files.reject!   { |fn| fn.include? ".gem" }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "sinatra", "~> 1.4"
end
