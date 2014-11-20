require 'rails_helper'

feature 'Update admin_emails' do
  background do
    @location = create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'when no admin_emails exist' do
    expect(page).to have_no_xpath("//input[@name='location[admin_emails][]']")
    expect(page).to_not have_link 'Delete this admin permanently'
  end

  scenario 'by adding 2 new admins', :js do
    add_two_admins
    total_admins = page.
                   all(:xpath, "//input[@name='location[admin_emails][]']")
    expect(total_admins.length).to eq 2
    delete_all_admins
    expect(page).to have_no_xpath("//input[@name='location[admin_emails][]']")
  end

  scenario 'with empty admin', :js do
    find_link('Add a new admin email').trigger('click')
    click_button 'Save changes'
    expect(page).to have_no_xpath("//input[@name='location[admin_emails][]']")
  end

  scenario 'with 2 admins but one is empty', :js do
    find_link('Add a new admin email').trigger('click')
    fill_in 'location[admin_emails][]', with: 'moncef@samaritanhouse.com'
    find_link('Add a new admin email').trigger('click')
    click_button 'Save changes'
    total_admins = all(:xpath, "//input[@name='location[admin_emails][]']")
    expect(total_admins.length).to eq 1
  end

  scenario 'with 2 admin_emails but only one is invalid', :js do
    @location.update!(admin_emails: ['foo@ruby.org'])
    visit '/admin/locations/vrs-services'
    find_link('Add a new admin email').trigger('click')
    admin_emails = page.
                   all(:xpath, "//input[@name='location[admin_emails][]']")
    fill_in admin_emails[-1][:id], with: 'Alexandria'
    click_button 'Save changes'
    total_fields_with_errors = page.all(:css, '.field_with_errors')
    expect(total_fields_with_errors.length).to eq 1
  end

  scenario 'with invalid admin', :js do
    find_link('Add a new admin email').trigger('click')
    fill_in 'location[admin_emails][]', with: 'moncefsamaritanhouse.com'
    click_button 'Save changes'
    expect(page).
      to have_content 'moncefsamaritanhouse.com is not a valid email'
    expect(page).to have_css('.field_with_errors')
  end
end
