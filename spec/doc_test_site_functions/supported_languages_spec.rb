# frozen_string_literal: true

require 'spec_helper'

describe DocTestSiteFunctions,
         '.supported_languages' do
  it 'supported languages is an array' do
    expect(described_class.supported_languages).to be_a(Array)
  end

  it 'supported languages contains english' do
    expect(described_class.supported_languages).to include('English')
  end

  describe 'Check for Serbian Cyrillic included in supported languages' do
    serbian_cyrillic = 'Serbian (Cyrillic)'

    it '8.1 includes serbian cyrillic' do
      doc_ver = OnlyofficeDocumentserverTestingFramework::DocumentServerVersion.new(8, 1)
      expect(described_class.supported_languages(doc_ver)).to include(serbian_cyrillic)
    end

    it '8.0 do not include serbian cyrillic' do
      doc_ver = OnlyofficeDocumentserverTestingFramework::DocumentServerVersion.new(8, 0)
      expect(described_class.supported_languages(doc_ver)).not_to include(serbian_cyrillic)
    end
  end

  describe 'All version include English' do
    versions = [[8, 1], [8, 0], [7, 4], [7, 2], [7, 1], [6, 2], [6, 0]]
    versions.each do |version|
      it "supported languages for version #{version.join('.')} is an array" do
        doc_ver = OnlyofficeDocumentserverTestingFramework::DocumentServerVersion.new(*version)
        expect(described_class.supported_languages(doc_ver)).to include('English')
      end
    end
  end
end
