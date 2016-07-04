# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'consul_bridge/version'

Gem::Specification.new do |spec|
  spec.name          = "consul_bridge"
  spec.version       = ConsulBridge::VERSION
  spec.authors       = ["Ryan Schlesinger"]
  spec.email         = ["ryan@outstand.com"]

  spec.summary       = %q{Discover consul master nodes and join local agent}
  spec.homepage      = 'https://github.com/outstand/consul_bridge'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'thor', '~> 0.19'
  spec.add_runtime_dependency 'excon', '~> 0.49.0'
  spec.add_runtime_dependency 'fog-aws', '~> 0.9'
  spec.add_runtime_dependency 'mime-types', '~> 3.0'
  spec.add_runtime_dependency 'docker-api', '~> 1.28'
  spec.add_runtime_dependency 'concurrent-ruby', '~> 1.0'
  spec.add_runtime_dependency 'concurrent-ruby-edge', '~> 0.2'
  spec.add_runtime_dependency 'metaractor', '~> 0.5'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "fog-local", "~> 0.3"
end
