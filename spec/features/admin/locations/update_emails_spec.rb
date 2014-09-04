require 'rails_helper'

feature 'Update emails' do
  background do
    @location = create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'with empty email', :js do
    click_link 'Add a new general email'
    click_button 'Save changes'
    expect(page).to have_no_xpath("//input[@name='location[emails][]']")
  end

  scenario 'with valid email', :js do
    click_link 'Add a new general email'
    fill_in 'location[emails][]', with: 'moncefbelyamani@samaritanhousesanmateo.org'
    click_button 'Save changes'
    expect(find_field('location[emails][]').value).
      to eq 'moncefbelyamani@samaritanhousesanmateo.org'
  end

  scenario 'when clearing out existing email but not deleting it' do
    @location.update!(emails: ['foo@ruby.org'])
    visit '/admin/locations/vrs-services'
    fill_in 'location[emails][]', with: ''
    click_button 'Save changes'
    expect(page).to have_no_xpath("//input[@name='location[emails][]']")
  end

  scenario 'with an invalid email' do
    @location.update!(emails: ['foo@ruby.org'])
    visit '/admin/locations/vrs-services'
    fill_in 'location_emails_0', with: 'example.org'
    click_button 'Save changes'
    expect(page).to have_content 'example.org is not a valid email'
    expect(page).to have_css('.field_with_errors')
  end

  scenario 'by adding 2 new emails', :js do
    add_two_emails

    emails = all(:xpath, "//input[@name='location[emails][]']")
    expect(emails.length).to eq 2

    email_id = emails[-1][:id]
    expect(find_field(email_id).value).to eq 'ruby@foo.com'

    delete_all_emails
    expect(page).to have_no_xpath("//input[@name='location[emails][]']")
  end

  scenario 'with 2 emails but one is empty', :js do
    @location.update!(emails: ['foo@ruby.org'])
    visit '/admin/locations/vrs-services'
    click_link 'Add a new general email'
    click_button 'Save changes'
    total_emails = all(:xpath, "//input[@name='location[emails][]']")
    expect(total_emails.length).to eq 1
  end

  scenario 'with 2 emails but only one is invalid', :js do
    @location.update!(emails: ['foo@ruby.org'])
    visit '/admin/locations/vrs-services'
    click_link 'Add a new general email'
    emails = page.
        all(:xpath, "//input[@name='location[emails][]']")
    fill_in emails[-1][:id], with: 'Alexandria'
    click_button 'Save changes'
    total_fields_with_errors = page.all(:css, '.field_with_errors')
    expect(total_fields_with_errors.length).to eq 1
  end
end
