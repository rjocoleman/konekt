# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'konekt/version'

Gem::Specification.new do |spec|
  spec.name          = 'konekt'
  spec.version       = Konekt::VERSION
  spec.authors       = ['Robert Coleman']
  spec.email         = ['github@robert.net.nz']

  spec.summary       = %q{A Ruby library to interact with Konekt Cloud via Ruby and Rails.}
  spec.description   = %q{A Ruby library to interact with Konekt Cloud via Ruby and Rails.}
  spec.homepage      = 'https://github.com/rjocoleman/konekt'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake',    '~> 10.0'
  spec.add_development_dependency 'pry',     '~> 0.10'
  spec.add_development_dependency 'rspec',   '~> 3.3'
end
