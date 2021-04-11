require 'rails_helper'

describe 'Update accepted_payments' do
  before do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  it 'with no accepted_payments' do
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.accepted_payments).to eq []
  end

  it 'with one accepted payment', :js do
    select2('Cash', 'service_accepted_payments', multiple: true)
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.accepted_payments).to eq ['Cash']
  end

  it 'with two accepted_payments', :js do
    select2('Cash', 'service_accepted_payments', multiple: true)
    select2('Check', 'service_accepted_payments', multiple: true)
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.accepted_payments).to eq %w[Cash Check]
  end

  it 'removing an accepted payment', :js do
    @service.update!(accepted_payments: %w[Cash Check])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    within '#s2id_service_accepted_payments' do
      first('.select2-search-choice-close').click
    end
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.accepted_payments).to eq ['Check']
  end
end
