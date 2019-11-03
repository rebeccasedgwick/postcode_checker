require 'spec_helper'

RSpec.feature 'Check a postcode', :type => :feature do
  scenario 'User checks a whitelisted postcode' do
    visit root_path
      fill_in 'Postcode', with: 'sh241aa'
      click_button 'Check postcode'
    expect(page).to have_text('Great news, this postcode is in our service area')
  end

  scenario 'User checks a postcode that is not whitelisted' do
    visit root_path
      fill_in 'Postcode', with: 'abcdef'
      click_button 'Check postcode'
    expect(page).to have_text("Unfortunately we couldn't find this postcode in our service area")
  end
end
