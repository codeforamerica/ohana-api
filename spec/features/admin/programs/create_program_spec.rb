require 'rails_helper'

describe 'Create a new program' do
  before do
    create(:location)
    login_super_admin
    visit('/admin/programs/new')
  end

  it 'with all required fields', :js do
    select2('Parent Agency', 'org-name')
    fill_in 'program_name', with: 'New Program'
    click_button I18n.t('admin.buttons.create_program')
    expect(page).to have_content t('admin.notices.program_created')

    click_link 'New Program'
    expect(find_field('program_name').value).to eq 'New Program'
  end

  it 'without any required fields' do
    click_button I18n.t('admin.buttons.create_program')
    expect(page).to have_content "Name can't be blank for Program"
    expect(page).to have_content 'Organization must exist'
  end

  it 'with alternate_name', :js do
    select2('Parent Agency', 'org-name')
    fill_in 'program_name', with: 'New Program'
    fill_in 'program_alternate_name', with: 'Alternate name'
    click_button I18n.t('admin.buttons.create_program')
    click_link 'New Program'

    expect(find_field('program_alternate_name').value).to eq 'Alternate name'
  end
end
