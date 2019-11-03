require 'rails_helper'

RSpec.describe WhitelistedPostcode, type: :model do
  it 'can be created' do
    expect{ WhitelistedPostcode.create(postcode: 'sh241aa') }.to change(WhitelistedPostcode, :count).by(1)
  end

  context 'on save' do
    it 'normalises the postcode' do
      whitelisted_postcode = WhitelistedPostcode.create!(postcode: 'SH24 1AA')
      expect(whitelisted_postcode.postcode).to eq('sh241aa')
    end
  end
end
