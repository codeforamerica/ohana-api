require 'rails_helper'

feature 'Signing up' do
  scenario 'with all required fields present and valid' do
    sign_up_admin('Moncef', 'moncef@foo.com', 'ohanatest', 'ohanatest')
    expect(page).to have_content 'activate your account'
    expect(current_path).to eq(admin_dashboard_path)
  end

  scenario 'with custom confirmation email address' do
    sign_up_admin('Moncef', 'moncef@foo.com', 'ohanatest', 'ohanatest')
    expect(first_email.from.first).to eq('registration@ohanapi.org')
    reset_email
  end

  scenario 'with name missing' do
    sign_up_admin('', 'moncef@foo.com', 'ohanatest', 'ohanatest')
    expect(page).to have_content "Name can't be blank"
  end

  scenario 'with email missing' do
    sign_up_admin('Moncef', '', 'ohanatest', 'ohanatest')
    expect(page).to have_content "Email can't be blank"
  end

  scenario 'with password missing' do
    sign_up_admin('Moncef', 'moncef@foo.com', '', 'ohanatest')
    expect(page).to have_content "Password can't be blank"
  end

  scenario 'with password confirmation missing' do
    sign_up_admin('Moncef', 'moncef@foo.com', 'ohanatest', '')
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario "when password and confirmation don't match" do
    sign_up_admin('Moncef', 'moncef@foo.com', 'ohanatest', 'ohana')
    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end
