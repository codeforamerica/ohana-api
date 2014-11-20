require 'rails_helper'

feature 'Update accepted_payments' do
  background do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  scenario 'with no accepted_payments' do
    click_button 'Save changes'
    expect(@service.reload.accepted_payments).to eq []
  end

  scenario 'with one accepted payment', :js do
    select2('Cash', 'service_accepted_payments', multiple: true)
    click_button 'Save changes'
    expect(@service.reload.accepted_payments).to eq ['Cash']
  end

  scenario 'with two accepted_payments', :js do
    select2('Cash', 'service_accepted_payments', multiple: true)
    select2('Check', 'service_accepted_payments', multiple: true)
    click_button 'Save changes'
    expect(@service.reload.accepted_payments).to eq %w(Cash Check)
  end

  scenario 'removing an accepted payment', :js do
    @service.update!(accepted_payments: %w(Cash Check))
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    within '#s2id_service_accepted_payments' do
      first('.select2-search-choice-close').click
    end
    click_button 'Save changes'
    expect(@service.reload.accepted_payments).to eq ['Check']
  end
end
