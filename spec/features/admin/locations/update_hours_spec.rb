require 'spec_helper'

feature 'Update hours' do
  background do
    create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'with empty hours' do
    fill_in 'location_hours', with: ''
    click_button 'Save changes'
    expect(find_field('location_hours').value).to be_nil
  end

  scenario 'with valid hours' do
    fill_in 'location_hours', with: 'Monday-Friday 10am-5pm'
    click_button 'Save changes'
    expect(find_field('location_hours').value).to eq 'Monday-Friday 10am-5pm'
  end
end
