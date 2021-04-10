require 'rails_helper'

describe 'Update funding_sources' do
  before do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  it 'with no funding_sources' do
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.funding_sources).to eq []
  end

  it 'with one funding source', :js do
    select2('State', 'service_funding_sources', multiple: true)
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.funding_sources).to eq ['State']
  end

  it 'with two funding_sources', :js do
    select2('State', 'service_funding_sources', multiple: true)
    select2('County', 'service_funding_sources', multiple: true)
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.funding_sources).to eq %w[State County]
  end

  it 'removing a funding source', :js do
    @service.update!(funding_sources: %w[State County])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    within '#s2id_service_funding_sources' do
      first('.select2-search-choice-close').click
    end
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.funding_sources).to eq ['County']
  end
end
