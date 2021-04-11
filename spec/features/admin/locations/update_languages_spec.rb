require 'rails_helper'

describe 'Update languages' do
  before do
    @location = create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  it 'with no languages' do
    click_button I18n.t('admin.buttons.save_changes')
    expect(@location.reload.languages).to eq []
  end

  it 'with one language', :js do
    select2('French', 'location_languages', multiple: true)
    click_button I18n.t('admin.buttons.save_changes')
    expect(@location.reload.languages).to eq ['French']
  end

  it 'with two languages', :js do
    select2('French', 'location_languages', multiple: true)
    select2('Spanish', 'location_languages', multiple: true)
    click_button I18n.t('admin.buttons.save_changes')
    expect(@location.reload.languages).to eq %w[French Spanish]
  end

  it 'removing a language', :js do
    @location.update!(languages: %w[Arabic French])
    visit '/admin/locations/vrs-services'
    first('.select2-search-choice-close').click
    click_button I18n.t('admin.buttons.save_changes')
    expect(@location.reload.languages).to eq ['French']
  end
end
