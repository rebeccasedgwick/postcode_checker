# frozen_string_literal: true

require 'spec_helper'

RSpec.feature 'Administrate the postcode whitelist', type: :feature do
  context 'when a given postcode is already whitelisted' do
    before do
      WhitelistedPostcode.create!(postcode: 'SH24 1AA')
    end

    scenario 'User tries to add the given postcode to the whitelist' do
      visit whitelisted_postcodes_path
      click_link 'Add new postcode'
      fill_in 'Postcode', with: 'SH24 1AA'
      click_button 'Add new postcode'
      expect(page).to have_text('Postcode has already been taken')
    end

    scenario 'User can delete the given postcode from the whitelist' do
      visit whitelisted_postcodes_path
      click_link 'Delete'
      expect(page).not_to have_content('sh241aa')
    end

    scenario 'User can update the given postcode' do
      visit whitelisted_postcodes_path
      click_link 'Edit'
      fill_in 'Postcode', with: 'SH24 1AB'
      click_button 'Edit postcode'
      expect(page).not_to have_content('sh241aa')
      expect(page).to have_content('sh241ab')
    end
  end

  context 'when a user wants to whitelist a new postcode and look it up' do
    scenario 'user adds postcode to the whitelist' do
      visit whitelisted_postcodes_path
      click_link 'Add new postcode'
      fill_in 'Postcode', with: 'SH24 1AA'
      click_button 'Add new postcode'
      visit root_path
      fill_in 'Postcode', with: 'SH24 1AA'
      click_button 'Check postcode'
      expect(page).to have_text('Great news, this postcode is in our service area')
    end
  end
end
