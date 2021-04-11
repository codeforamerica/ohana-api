require 'rails_helper'

describe 'Delete program' do
  before do
    loc = create(:location)
    program = loc.organization.programs.create!(attributes_for(:program))
    login_super_admin
    visit admin_program_path(program)
  end

  it 'when submitting warning', :js do
    find_link(I18n.t('admin.buttons.delete_program')).click
    find_link(I18n.t('admin.buttons.confirm_delete_program')).click
    using_wait_time 5 do
      expect(page).to have_current_path admin_programs_path, ignore_query: true
    end
    expect(page).not_to have_link 'Collection of Services'
  end

  it 'when canceling warning', :js do
    find_link(I18n.t('admin.buttons.delete_program')).click
    find_button('Close').click
    visit '/admin/programs'
    expect(page).to have_link 'Collection of Services'
  end
end
