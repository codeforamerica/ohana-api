require 'spec_helper'

feature 'Creating a new API Application' do
  # The create_api_app' methods is defined in
  # spec/support/features/session_helpers.rb

  # The 'login_as' method is a Warden test helper that
  # allows you to simulate a user login without having
  # to fill in the sign in form every time. Since we're
  # not testing the signing in part of the app here, we
  # can take advantage of the Warden helper and speed up
  # our integration tests.

  # All other methods are part of the Capybara DSL
  # https://github.com/jnicklas/capybara
  background do
    user = FactoryGirl.create(:user)
    login_as(user, scope: :user)
    visit '/api_applications'
  end

  scenario 'visit apps with no apps created' do
    expect(page).to_not have_content 'http'
  end

  scenario 'with valid fields' do
    create_api_app('my awesome app', 'http://codeforamerica.org', '')
    expect(page).to have_content 'Application was successfully created.'
    expect(page).to_not have_content 'API token is already taken'
    expect(page.text).to match(/API Token: \w+/)
  end

  scenario 'with blank fields' do
    create_api_app('', '', '')
    expect(page).to have_content "Name can't be blank"
    expect(page).to have_content "Main url can't be blank"
    expect(page).to_not have_content 'API Token:'
  end

  scenario 'with invalid main url' do
    create_api_app('test app', 'ohana', 'http://callback')
    expect(page).to have_content 'ohana is not a valid URL'
    expect(page).to_not have_content 'API Token:'
  end

  scenario 'with invalid callback url' do
    create_api_app('test app', 'http://localhost', 'callback')
    expect(page).to have_content 'callback is not a valid URL'
    expect(page).to_not have_content 'API Token:'
  end
end
