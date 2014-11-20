require 'rails_helper'

feature 'Update funding_sources' do
  background do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  scenario 'when no funding_sources exist', :js do
    within '#s2id_service_funding_sources' do
      expect(page).to have_no_css('.select2-search-choice-close')
    end
  end

  scenario 'with one funding_source', :js do
    select2('Knight Foundation Grant', 'service_funding_sources', multiple: true, tag: true)
    click_button 'Save changes'
    expect(@service.reload.funding_sources).to eq ['Knight Foundation Grant']
  end

  scenario 'with two funding_sources', :js do
    select2('first', 'service_funding_sources', multiple: true, tag: true)
    select2('second', 'service_funding_sources', multiple: true, tag: true)
    click_button 'Save changes'
    expect(@service.reload.funding_sources).to eq %w(first second)
  end

  scenario 'removing a funding_source', :js do
    @service.update!(funding_sources: %w(County Donations))
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    within '#s2id_service_funding_sources' do
      first('.select2-search-choice-close').click
    end
    click_button 'Save changes'
    expect(@service.reload.funding_sources).to eq ['Donations']
  end
end
