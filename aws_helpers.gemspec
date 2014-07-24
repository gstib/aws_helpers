# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aws_helpers/version'

Gem::Specification.new do |spec|
  spec.name          = 'aws_helpers'
  spec.version       = AwsHelpers::VERSION
  spec.authors       = ['Grant Tibbey']
  spec.email         = ['granttibbey@hotmail.com']
  spec.summary       = %q{AWS Helpers to perform common functionality}
  spec.description   = %q{AWS Helpers to perform common functionality}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']


  spec.add_dependency 'aws-sdk-core', '~> 2.0.0.rc12'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
end
