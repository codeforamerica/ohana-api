require 'rails_helper'

feature 'Update keywords' do
  background do
    location = create(:location)
    @service = location.services.create!(
      attributes_for(:service).merge(keywords: []))
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  scenario 'when no keywords exist', :js do
    expect(page).to have_no_css('.select2-search-choice-close')
  end

  scenario 'with one keyword', :js do
    select2('ligal', 'service_keywords', multiple: true, tag: true)
    click_button 'Save changes'
    expect(@service.reload.keywords).to eq ['ligal']
  end

  scenario 'with two keywords', :js do
    select2('first', 'service_keywords', multiple: true, tag: true)
    select2('second', 'service_keywords', multiple: true, tag: true)
    click_button 'Save changes'
    expect(@service.reload.keywords).to eq %w(first second)
  end

  scenario 'removing a keyword', :js do
    @service.update!(keywords: %w(resume computer))
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    within '#s2id_service_keywords' do
      first('.select2-search-choice-close').click
    end
    click_button 'Save changes'
    expect(@service.reload.keywords).to eq ['computer']
  end
end
