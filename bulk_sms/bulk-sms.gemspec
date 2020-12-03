lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'clients/version'

Gem::Specification.new do |spec|
  spec.name          = 'bulk-sms'
  spec.version       = BulkSMS::VERSION
  spec.authors       = ['GreatLearning Tech Team']
  spec.email         = ['dev@greatleaning.in']

  spec.summary       = 'Ruby SMS Client SDK for GreatLearning'

  spec.files         = Dir.glob('{bin,lib}/**/*')
  spec.files += %w[LICENSE NOTICE README.md]
  spec.license       = 'Apache-2.0'
  spec.require_paths = ['lib', 'lib/clients/*']

  spec.add_development_dependency 'bundler', '~> 2.0.1'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
