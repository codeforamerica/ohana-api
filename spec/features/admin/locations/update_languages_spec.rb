require 'rails_helper'

feature 'Update languages' do
  background do
    @location = create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'with no languages' do
    click_button 'Save changes'
    expect(@location.reload.languages).to eq []
  end

  scenario 'with one language', :js do
    select2('French', 'location_languages', multiple: true)
    click_button 'Save changes'
    expect(@location.reload.languages).to eq ['French']
  end

  scenario 'with two languages', :js do
    select2('French', 'location_languages', multiple: true)
    select2('Spanish', 'location_languages', multiple: true)
    click_button 'Save changes'
    expect(@location.reload.languages).to eq %w(French Spanish)
  end

  scenario 'removing a language', :js do
    @location.update!(languages: %w(Arabic French))
    visit '/admin/locations/vrs-services'
    first('.select2-search-choice-close').click
    click_button 'Save changes'
    expect(@location.reload.languages).to eq ['French']
  end
end
