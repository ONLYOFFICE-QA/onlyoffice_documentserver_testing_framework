# frozen_string_literal: true

require_relative 'lib/onlyoffice_documentserver_testing_framework/name'
require_relative 'lib/onlyoffice_documentserver_testing_framework/version'

Gem::Specification.new do |s|
  s.name = OnlyofficeDocumentserverTestingFramework::Name::STRING
  s.version = OnlyofficeDocumentserverTestingFramework::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.4'
  s.authors = ['ONLYOFFICE', 'Pavel Lobashov']
  s.summary = 'ONLYOFFICE DocumentServer testing framework'
  s.description = 'ONLYOFFICE DocumentServer testing framework, used in QA'
  s.homepage = "https://github.com/onlyoffice-testing-robot/#{s.name}"
  s.metadata = {
    'bug_tracker_uri' => "#{s.homepage}/issues",
    'changelog_uri' => "#{s.homepage}/blob/master/CHANGELOG.md",
    'documentation_uri' => "https://www.rubydoc.info/gems/#{s.name}",
    'homepage_uri' => s.homepage,
    'source_code_uri' => s.homepage
  }
  s.email = ['shockwavenn@gmail.com']
  s.files = Dir['lib/**/*']
  s.add_runtime_dependency('onlyoffice_logger_helper', '~> 1')
  s.add_runtime_dependency('onlyoffice_webdriver_wrapper', '~> 0')
  s.add_development_dependency('overcommit', '0.55.0')
  s.add_development_dependency('rake', '13.0.1')
  s.add_development_dependency('rspec', '3.9.0')
  s.add_development_dependency('rubocop', '0.89.1')
  s.add_development_dependency('rubocop-performance', '1.7.1')
  s.add_development_dependency('rubocop-rake', '0.5.1')
  s.add_development_dependency('rubocop-rspec', '1.43.0')
  s.add_development_dependency('simplecov', '0.18.5')
  s.add_development_dependency('yard', '0.9.25')
  s.license = 'AGPL-3.0'
end
