# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostcodeValidator do
  let(:subject_whitelisted_lsoa) { described_class.new('SE1 7QD') }
  let(:subject_whitelisted_postcode) { described_class.new('SH24 1AA') }
  let(:subject_invalid_postcode) { described_class.new('INVALID') }
  let(:subject_valid_postcode_not_serviced) { described_class.new('TR19 7AA') }

  describe 'initialize' do
    it 'normalises the postcode' do
      expect(subject_whitelisted_lsoa.postcode).to eq('se17qd')
    end
  end

  describe '#valid?' do
    context 'when the postcode is whitelisted' do
      before do
        WhitelistedPostcode.create!(postcode: 'SH24 1AA')
      end
      it 'returns true if postcode is whitelisted' do
        expect(subject_whitelisted_postcode).to receive(:whitelisted_postcode?).and_return(true)
        expect(subject_whitelisted_postcode.valid?).to eq(true)
      end
    end

    context 'if postcode is found by API' do
      it 'returns true if LSOA is whitelisted' do
        VCR.use_cassette('postcodes-io-whitelisted-lsoa') do
          expect(subject_whitelisted_lsoa).to receive(:whitelisted_lsoa?).and_return(true)
          expect(subject_whitelisted_lsoa.valid?).to eq(true)
        end
      end
      it 'returns false if LSOA is not whitelisted' do
        VCR.use_cassette('postcodes-io-postcode_not_serviced') do
          expect(subject_valid_postcode_not_serviced).to receive(:whitelisted_lsoa?).and_return(false)
          expect(subject_valid_postcode_not_serviced.valid?).to eq(false)
        end
      end
    end

    it 'returns false if the postcode is not found by API' do
      VCR.use_cassette('postcodes-io-invalid') do
        expect(subject_invalid_postcode.valid?).to eq(false)
      end
    end
  end

  describe '#whitelisted_postcode?' do
    context 'when the postcode is whitelisted' do
      before do
        WhitelistedPostcode.create!(postcode: 'SH24 1AA')
      end
      it 'returns true if the postcode is whitelisted' do
        expect(subject_whitelisted_postcode.whitelisted_postcode?).to eq(true)
      end
    end
    it 'returns false if the postcode is not whitelisted' do
      expect(subject_valid_postcode_not_serviced.whitelisted_postcode?).to eq(false)
    end
  end

  describe '#fetch_postcode_details' do
    it 'returns parsed JSON response if response is valid' do
      VCR.use_cassette('postcodes-io-whitelisted-lsoa') do
        json = subject_whitelisted_lsoa.fetch_postcode_details
        expect(json['result']['country']).to eq('England')
      end
    end
    it 'returns nil if response is not valid' do
      VCR.use_cassette('postcodes-io-invalid') do
        value = subject_invalid_postcode.fetch_postcode_details
        expect(value).to eq(nil)
      end
    end
  end

  describe '#whitelisted_lsoa?' do
    before do
      stub_const('PostcodeValidator::LSOA_WHITELIST', %w[Lambeth Southwark])
    end
    it 'returns true if LSOA is whitelisted' do
      expect(subject_whitelisted_lsoa.whitelisted_lsoa?('Southwark
        034A')).to eq(true)
    end
    it 'returns false if LSOA is not whitelisted' do
      expect(subject_valid_postcode_not_serviced.whitelisted_lsoa?('Cornwall 069C')).to eq(false)
    end
  end
end
