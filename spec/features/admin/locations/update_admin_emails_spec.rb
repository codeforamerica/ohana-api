require 'rails_helper'

feature 'Update admin_emails' do
  background do
    create(:location)
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
    click_link 'Add a new admin'
    click_button 'Save changes'
    expect(page).to have_no_xpath("//input[@name='location[admin_emails][]']")
  end

  scenario 'with 2 admins but one is empty', :js do
    click_link 'Add a new admin'
    fill_in 'location[admin_emails][]', with: 'moncef@samaritanhouse.com'
    click_link 'Add a new admin'
    click_button 'Save changes'
    total_admins = all(:xpath, "//input[@name='location[admin_emails][]']")
    expect(total_admins.length).to eq 1
  end

  scenario 'with invalid admin', :js do
    click_link 'Add a new admin'
    fill_in 'location[admin_emails][]', with: 'moncefsamaritanhouse.com'
    click_button 'Save changes'
    expect(page).
      to have_content 'moncefsamaritanhouse.com is not a valid email'
  end
end
