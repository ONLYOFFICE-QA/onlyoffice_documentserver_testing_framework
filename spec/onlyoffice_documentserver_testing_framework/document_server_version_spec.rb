# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeDocumentserverTestingFramework::DocumentServerVersion do
  let(:first_version) { described_class.new(5, 4, 99, 123) }
  let(:major_increase) { described_class.new(5, 5, 0, 5) }

  it 'Server version is equal to self' do
    expect(first_version).to eq(first_version)
  end

  it 'After major increase version is greater' do
    expect(major_increase).to be > first_version
  end
end
