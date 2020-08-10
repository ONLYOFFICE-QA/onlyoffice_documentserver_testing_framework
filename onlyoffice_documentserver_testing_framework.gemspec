# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'onlyoffice_documentserver_testing_framework/version'
Gem::Specification.new do |s|
  s.name = 'onlyoffice_documentserver_testing_framework'
  s.version = OnlyofficeDocumentserverTestingFramework::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.4'
  s.authors = ['Pavel Lobashov']
  s.summary = 'ONLYOFFICE DocumentServer testing framework'
  s.description = 'onlyoffice_documentserver_testing_framework'
  s.email = ['shockwavenn@gmail.com']
  s.files = `git ls-files lib LICENSE.txt README.md`.split($RS)
  s.homepage = 'https://github.com/onlyoffice-testing-robot/onlyoffice_documentserver_testing_framework'
  s.add_runtime_dependency('onlyoffice_logger_helper', '~> 1')
  s.add_runtime_dependency('onlyoffice_webdriver_wrapper', '~> 0')
  s.add_development_dependency('overcommit', '0.55.0')
  s.add_development_dependency('rake', '13.0.1')
  s.add_development_dependency('rspec', '3.9.0')
  s.add_development_dependency('rubocop', '0.89.1')
  s.add_development_dependency('rubocop-performance', '1.7.1')
  s.add_development_dependency('rubocop-rake', '0.5.1')
  s.add_development_dependency('simplecov', '0.18.5')
  s.license = 'AGPL-3.0'
end
