require 'rails_helper'

describe 'Update languages' do
  before do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  it 'with no languages' do
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.languages).to eq []
  end

  it 'with one language', :js do
    select2('French', 'service_languages', multiple: true)
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.languages).to eq ['French']
  end

  it 'with two languages', :js do
    select2('French', 'service_languages', multiple: true)
    select2('Spanish', 'service_languages', multiple: true)
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.languages).to eq %w[French Spanish]
  end

  it 'removing a language', :js do
    @service.update!(languages: %w[Arabic French])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    within '#s2id_service_languages' do
      first('.select2-search-choice-close').click
    end
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.languages).to eq ['French']
  end
end
