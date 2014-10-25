require 'rails_helper'

feature 'Delete program' do
  background do
    loc = create(:location)
    program = loc.organization.programs.create!(attributes_for(:program))
    login_super_admin
    visit admin_program_path(program)
  end

  scenario 'when submitting warning', :js do
    find_link('Permanently delete this program').click
    find_link('I understand the consequences, delete this program').click
    using_wait_time 1 do
      expect(current_path).to eq admin_programs_path
    end
    expect(page).not_to have_link 'Collection of Services'
  end

  scenario 'when canceling warning', :js do
    find_link('Permanently delete this program').click
    find_button('Close').click
    visit '/admin/programs'
    expect(page).to have_link 'Collection of Services'
  end
end
