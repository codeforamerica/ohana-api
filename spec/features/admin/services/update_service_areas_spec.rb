require 'rails_helper'

describe 'Update service areas' do
  before do
    location = create(:location)
    @service = location.services.
               create!(attributes_for(:service).merge(keywords: []))
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  it 'when no service areas exist', :js do
    expect(page).to have_no_css('.select2-search-choice-close')
  end

  it 'with one service area', :js do
    select2('Belmont', 'service_service_areas', multiple: true)
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.service_areas).to eq ['Belmont']
  end

  it 'with two service areas', :js do
    select2('Belmont', 'service_service_areas', multiple: true)
    select2('Atherton', 'service_service_areas', multiple: true)
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.service_areas).to eq %w[Atherton Belmont]
  end

  it 'removing a service area', :js do
    @service.update!(service_areas: %w[Atherton Belmont])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    within '#s2id_service_service_areas' do
      first('.select2-search-choice-close').click
    end
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.service_areas).to eq ['Belmont']
  end
end
