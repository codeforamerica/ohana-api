require 'rails_helper'

describe 'Update name' do
  before do
    org = create(:organization)
    org.contacts.create!(attributes_for(:contact))
    login_super_admin
    visit '/admin/organizations/parent-agency'
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
    expect(page).to have_content 'Contact was successfully updated.'
    expect(find_field('contact_name').value).to eq 'Monfresh'
  end
end
