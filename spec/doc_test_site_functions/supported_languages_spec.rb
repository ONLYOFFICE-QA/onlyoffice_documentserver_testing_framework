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
end
