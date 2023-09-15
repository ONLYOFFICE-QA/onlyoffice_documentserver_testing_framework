# frozen_string_literal: true

require_relative 'lib/onlyoffice_documentserver_testing_framework/name'
require_relative 'lib/onlyoffice_documentserver_testing_framework/version'

Gem::Specification.new do |s|
  s.name = OnlyofficeDocumentserverTestingFramework::Name::STRING
  s.version = OnlyofficeDocumentserverTestingFramework::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 3.0'
  s.authors = ['ONLYOFFICE', 'Pavel Lobashov']
  s.summary = 'ONLYOFFICE DocumentServer testing framework'
  s.description = 'ONLYOFFICE DocumentServer testing framework, used in QA'
  s.homepage = "https://github.com/ONLYOFFICE-QA/#{s.name}"
  s.metadata = {
    'bug_tracker_uri' => "#{s.homepage}/issues",
    'changelog_uri' => "#{s.homepage}/blob/master/CHANGELOG.md",
    'documentation_uri' => "https://www.rubydoc.info/gems/#{s.name}",
    'homepage_uri' => s.homepage,
    'source_code_uri' => s.homepage,
    'rubygems_mfa_required' => 'true'
  }
  s.email = ['shockwavenn@gmail.com']
  s.files = Dir['lib/**/*']
  s.add_runtime_dependency('onlyoffice_logger_helper', '~> 1')
  s.add_runtime_dependency('onlyoffice_webdriver_wrapper', '~> 1', '>= 1.10.0')
  s.license = 'AGPL-3.0'
end
