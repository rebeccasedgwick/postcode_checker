# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostcodeValidator do
  let(:subject) do
    described_class.new('SE1 3GB')
  end

  describe 'initialize' do
    it 'normalises the postcode' do
      expect(subject.postcode).to eq('se13gb')
    end
  end

  describe '#valid?' do
    before do
      stub_const('PostcodeValidator::POSTCODE_WHITELIST', %w[se13gb sh241aa])
    end

    it 'returns true if the postcode is whitelisted' do
      expect(subject.valid?).to eq(true)
    end
    it 'returns false if the postcode is not whitelisted' do
      subject = described_class.new('invalid')
      expect(subject.valid?).to eq(false)
    end
  end
end
