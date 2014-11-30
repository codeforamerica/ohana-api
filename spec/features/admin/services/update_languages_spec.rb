require 'rails_helper'

feature 'Update languages' do
  background do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  scenario 'with no languages' do
    click_button 'Save changes'
    expect(@service.reload.languages).to eq []
  end

  scenario 'with one language', :js do
    select2('French', 'service_languages', multiple: true)
    click_button 'Save changes'
    expect(@service.reload.languages).to eq ['French']
  end

  scenario 'with two languages', :js do
    select2('French', 'service_languages', multiple: true)
    select2('Spanish', 'service_languages', multiple: true)
    click_button 'Save changes'
    expect(@service.reload.languages).to eq %w(French Spanish)
  end

  scenario 'removing a language', :js do
    @service.update!(languages: %w(Arabic French))
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    within '#s2id_service_languages' do
      first('.select2-search-choice-close').click
    end
    click_button 'Save changes'
    expect(@service.reload.languages).to eq ['French']
  end
end
