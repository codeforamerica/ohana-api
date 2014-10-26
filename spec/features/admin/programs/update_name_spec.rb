require 'rails_helper'

feature 'Update name' do
  background do
    loc = create(:location)
    program = loc.organization.programs.create!(attributes_for(:program))
    login_super_admin
    visit admin_program_path(program)
  end

  scenario 'with empty name' do
    fill_in 'program_name', with: ''
    click_button 'Save changes'
    expect(page).to have_content "Name can't be blank for Program"
  end

  scenario 'with valid name' do
    fill_in 'program_name', with: 'Youth Counseling'
    click_button 'Save changes'
    expect(page).to have_content 'Program was successfully updated.'
    expect(find_field('program_name').value).to eq 'Youth Counseling'
  end
end
