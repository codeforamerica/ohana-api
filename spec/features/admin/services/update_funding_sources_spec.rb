require 'rails_helper'

feature 'Update funding_sources' do
  background do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  scenario 'with no funding_sources' do
    click_button 'Save changes'
    expect(@service.reload.funding_sources).to eq []
  end

  scenario 'with one accepted payment', :js do
    select2('State', 'service_funding_sources', multiple: true)
    click_button 'Save changes'
    expect(@service.reload.funding_sources).to eq ['State']
  end

  scenario 'with two funding_sources', :js do
    select2('State', 'service_funding_sources', multiple: true)
    select2('County', 'service_funding_sources', multiple: true)
    click_button 'Save changes'
    expect(@service.reload.funding_sources).to eq %w(State County)
  end

  scenario 'removing an accepted payment', :js do
    @service.update!(funding_sources: %w(State County))
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    within '#s2id_service_funding_sources' do
      first('.select2-search-choice-close').click
    end
    click_button 'Save changes'
    expect(@service.reload.funding_sources).to eq ['County']
  end
end
