require 'rails_helper'

describe 'Update required_documents' do
  before do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  it 'with no required_documents' do
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.required_documents).to eq []
  end

  it 'with one required document', :js do
    select2('Bank Statement', 'service_required_documents', multiple: true)
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.required_documents).to eq ['Bank Statement']
  end

  it 'with two required_documents', :js do
    select2('Bank Statement', 'service_required_documents', multiple: true)
    select2('Picture ID', 'service_required_documents', multiple: true)
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.required_documents).to eq ['Bank Statement', 'Picture ID']
  end

  it 'removing a required document', :js do
    @service.update!(required_documents: ['Bank Statement', 'Picture ID'])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    within '#s2id_service_required_documents' do
      first('.select2-search-choice-close').click
    end
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.required_documents).to eq ['Picture ID']
  end
end
