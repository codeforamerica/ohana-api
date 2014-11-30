require 'rails_helper'

feature 'Update service areas' do
  background do
    location = create(:location)
    @service = location.services.
               create!(attributes_for(:service).merge(keywords: []))
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  scenario 'when no service areas exist', :js do
    expect(page).to have_no_css('.select2-search-choice-close')
  end

  scenario 'with one service area', :js do
    select2('Belmont', 'service_service_areas', multiple: true)
    click_button 'Save changes'
    expect(@service.reload.service_areas).to eq ['Belmont']
  end

  scenario 'with two service areas', :js do
    select2('Belmont', 'service_service_areas', multiple: true)
    select2('Atherton', 'service_service_areas', multiple: true)
    click_button 'Save changes'
    expect(@service.reload.service_areas).to eq %w(Atherton Belmont)
  end

  scenario 'removing a service area', :js do
    @service.update!(service_areas: %w(Atherton Belmont))
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    within '#s2id_service_service_areas' do
      first('.select2-search-choice-close').click
    end
    click_button 'Save changes'
    expect(@service.reload.service_areas).to eq ['Belmont']
  end
end
