require 'rails_helper'

feature 'Create a new program' do
  background do
    create(:location)
    login_super_admin
    visit('/admin/programs/new')
  end

  scenario 'with all required fields', :js do
    select2('Parent Agency', 'org-name')
    fill_in 'program_name', with: 'New Program'
    click_button 'Create program'
    expect(page).to have_content 'Program was successfully created.'

    click_link 'New Program'
    expect(find_field('program_name').value).to eq 'New Program'
  end

  scenario 'without any required fields' do
    click_button 'Create program'
    expect(page).to have_content "Name can't be blank for Program"
    expect(page).to have_content "Organization can't be blank for Program"
  end

  scenario 'with alternate_name', :js do
    select2('Parent Agency', 'org-name')
    fill_in 'program_name', with: 'New Program'
    fill_in 'program_alternate_name', with: 'Alternate name'
    click_button 'Create program'
    click_link 'New Program'

    expect(find_field('program_alternate_name').value).to eq 'Alternate name'
  end
end
