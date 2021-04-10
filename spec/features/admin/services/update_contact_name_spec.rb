require 'rails_helper'

describe 'Update contact name' do
  before do
    create_service
    @service.contacts.create!(attributes_for(:contact))
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
    click_link 'Moncef Belyamani'
  end

  it 'with empty name' do
    fill_in 'contact_name', with: ''
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content "Name can't be blank for Contact"
  end

  it 'with valid name' do
    fill_in 'contact_name', with: 'Monfresh'
    click_button I18n.t('admin.buttons.save_changes')

    contact_id = Contact.find_by(name: 'Monfresh').id
    service_path = "/admin/locations/vrs-services/services/#{@service.id}"

    expect(page).to have_current_path "#{service_path}/contacts/#{contact_id}"
    expect(page).to have_content 'Contact was successfully updated.'
    expect(find_field('contact_name').value).to eq 'Monfresh'
  end
end
