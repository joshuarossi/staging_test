# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bitfinex/version'

Gem::Specification.new do |spec|
  spec.name          = "bitfinex"
  spec.version       = Bitfinex::VERSION
  spec.authors       = ["joshuarossi"]
  spec.email         = ["maximojoshuarossi@gmail.com"]

  spec.summary       = "Write a short summary, because Rubygems requires one."
  spec.description   = "Write a longer description or delete this line."
  spec.homepage      = "https://github.com/bitfinexcom/bitfinex-api-rb"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency 'faraday', '~> 0.9.2', '>= 0.9.2'
  spec.add_runtime_dependency 'eventmachine', '~> 1.0', '>= 1.0.9.1'
  spec.add_runtime_dependency 'faraday-detailed_logger', '~> 1.0.0', '>= 1.0.0'
  spec.add_runtime_dependency 'faye-websocket', '~> 0.10.3'
  spec.add_runtime_dependency 'json', '~> 1.8.3','>= 1.8.3'
  spec.add_runtime_dependency 'faraday_middleware', '~> 0.10', '>= 0.10.0'
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "coveralls"
end
