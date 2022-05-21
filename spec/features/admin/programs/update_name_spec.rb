require 'rails_helper'

describe 'Update name' do
  before do
    loc = create(:location)
    program = loc.organization.programs.create!(attributes_for(:program))
    login_super_admin
    visit admin_program_path(program)
  end

  it 'with empty name' do
    fill_in 'program_name', with: ''
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content "Name can't be blank for Program"
  end

  it 'with valid name' do
    fill_in 'program_name', with: 'Youth Counseling'
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content t('admin.notices.program_updated')
    expect(find_field('program_name').value).to eq 'Youth Counseling'
  end
end
