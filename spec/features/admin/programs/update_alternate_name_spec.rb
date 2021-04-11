require 'rails_helper'

describe 'Update alternate name' do
  before do
    loc = create(:location)
    program = loc.organization.programs.create!(attributes_for(:program))
    login_super_admin
    visit admin_program_path(program)
  end

  it 'with valid alternate_name' do
    fill_in 'program_alternate_name', with: 'Youth Counseling'
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content 'Program was successfully updated.'
    expect(find_field('program_alternate_name').value).to eq 'Youth Counseling'
  end
end
