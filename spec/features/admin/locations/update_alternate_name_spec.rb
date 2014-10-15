require 'rails_helper'

feature 'Update alternate name' do
  background do
    create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'with alternate name' do
    fill_in 'location_alternate_name', with: 'Juvenile Sexual Responsibility Program'
    click_button 'Save changes'
    expect(find_field('location_alternate_name').value).
      to eq 'Juvenile Sexual Responsibility Program'
  end
end
