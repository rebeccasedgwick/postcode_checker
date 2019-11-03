require 'spec_helper'

RSpec.feature 'Check a postcode', type: :feature do
  scenario 'User checks a whitelisted postcode' do
    WhitelistedPostcode.create!(postcode: 'sh241aa')
    visit root_path
    fill_in 'Postcode', with: 'SH24 1AA'
    click_button 'Check postcode'
    expect(page).to have_text('Great news, this postcode is in our service area')
  end

  scenario 'User checks an invalid postcode' do
    visit root_path
    fill_in 'Postcode', with: 'invalid'
    VCR.use_cassette('postcodes-io-invalid') do
      click_button 'Check postcode'
    end
    expect(page).to have_text("Unfortunately we couldn't find this postcode in our service area")
  end

  scenario 'User checks an unserviced, non-whitelisted postcode' do
    visit root_path
    fill_in 'Postcode', with: 'TR19 7AA'
    VCR.use_cassette('postcodes-io-postcode_not_serviced') do
      click_button 'Check postcode'
    end
    expect(page).to have_text("Unfortunately we couldn't find this postcode in our service area")
  end

  scenario 'User checks a serviced LSOA area' do
    visit root_path
    fill_in 'Postcode', with: 'SE1 7QD'
    VCR.use_cassette('postcodes-io-whitelisted-lsoa') do
      click_button 'Check postcode'
    end
    expect(page).to have_text('Great news, this postcode is in our service area')
  end
end
