require 'spec_helper'

feature 'Signing up' do
  scenario 'with all required fields present and valid' do
    sign_up('Moncef', 'moncef@foo.com', 'ohanatest', 'ohanatest')
    expect(page).to have_content 'activate your account'
  end

  scenario 'with name missing' do
    sign_up('', 'moncef@foo.com', 'ohanatest', 'ohanatest')
    expect(page).to have_content "Name can't be blank"
  end

  scenario 'with email missing' do
    sign_up('Moncef', '', 'ohanatest', 'ohanatest')
    expect(page).to have_content "Email can't be blank"
  end

  scenario 'with password missing' do
    sign_up('Moncef', 'moncef@foo.com', '', 'ohanatest')
    expect(page).to have_content "Password can't be blank"
  end

  scenario 'with password confirmation missing' do
    sign_up('Moncef', 'moncef@foo.com', 'ohanatest', '')
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario "when password and confirmation don't match" do
    sign_up('Moncef', 'moncef@foo.com', 'ohanatest', 'ohana')
    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end
