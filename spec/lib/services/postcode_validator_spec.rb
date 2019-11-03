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
    it 'returns true if postcode is whitelisted' do
      expect(subject).to receive(:whitelisted_postcode?).and_return(true)
      expect(subject.valid?).to eq(true)
    end

    context 'if postcode is found by API' do
      it 'returns true if LSOA is whitelisted' do
        VCR.use_cassette('postcodes-io-valid') do
          expect(subject).to receive(:whitelisted_lsoa?).and_return(true)
          expect(subject.valid?).to eq(true)
        end
      end
      it 'returns false if LSOA is not whitelisted' do
        VCR.use_cassette('postcodes-io-valid') do
          expect(subject).to receive(:whitelisted_lsoa?).and_return(false)
          expect(subject.valid?).to eq(false)
        end
      end
    end

    it 'returns false if the postcode is not found by API' do
      subject = described_class.new('INVALID')
      VCR.use_cassette("postcodes-io-invalid") do
        expect(subject.valid?).to eq(false)
      end
    end
  end

  describe '#whitelisted_postcode??' do
    before do
      stub_const('PostcodeValidator::POSTCODE_WHITELIST', %w[se13gb sh241aa])
    end

    it 'returns true if the postcode is whitelisted' do
      expect(subject.whitelisted_postcode?).to eq(true)
    end
    it 'returns false if the postcode is not whitelisted' do
      subject = described_class.new('invalid')
      expect(subject.whitelisted_postcode?).to eq(false)
    end
  end

  describe '#fetch_postcode_details' do
    it 'returns parsed JSON response if response is valid' do
      VCR.use_cassette('postcodes-io-valid') do
        json = subject.fetch_postcode_details
        expect(json['result']['country']).to eq('England')
      end
    end
    it 'returns nil if response is not valid' do
      subject = described_class.new('INVALID')
      VCR.use_cassette('postcodes-io-invalid') do
        value = subject.fetch_postcode_details
        expect(value).to eq(nil)
      end
    end
  end

  describe '#whitelisted_lsoa?' do
    before do
      stub_const('PostcodeValidator::LSOA_WHITELIST', ['Lambeth', 'Southwark'])
    end
    it 'returns true if LSOA is whitelisted' do
      expect(subject.whitelisted_lsoa?('Lambeth')).to eq(true)
    end
    it 'returns false if LSOA is not whitelisted' do
      expect(subject.whitelisted_lsoa?('Greenland')).to eq(false)
    end
  end
end
