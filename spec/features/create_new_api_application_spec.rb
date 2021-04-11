require 'rails_helper'

describe 'Creating a new API Application' do
  # The 'create_api_app' method is defined in
  # spec/support/features/session_helpers.rb

  # The 'login_as' method is a Warden test helper that
  # allows you to simulate a user login without having
  # to fill in the sign in form every time. Since we're
  # not testing the signing in part of the app here, we
  # can take advantage of the Warden helper and speed up
  # our integration tests.

  # All other methods are part of the Capybara DSL
  # https://github.com/jnicklas/capybara
  before do
    user = FactoryBot.create(:user)
    login_as(user, scope: :user)
    visit '/api_applications'
  end

  it 'visit apps with no apps created' do
    expect(page).not_to have_content 'http'
  end

  it 'with valid fields' do
    create_api_app('my awesome app', 'http://codeforamerica.org', '')
    expect(page).to have_content 'Application was successfully created.'
    expect(page).not_to have_content 'API token is already taken'
    expect(page.text).to match(/API Token: \w+/)
    expect(page).to have_current_path edit_api_application_path(ApiApplication.last.id),
                                      ignore_query: true
  end

  it 'with blank fields' do
    create_api_app('', '', '')
    expect(page).to have_content "Name can't be blank"
    expect(page).to have_content "Main URL can't be blank"
    expect(page).not_to have_content 'API Token:'
  end

  it 'with invalid main url' do
    create_api_app('test app', 'ohana', 'http://callback')
    expect(page).to have_content 'ohana is not a valid URL'
    expect(page).not_to have_content 'API Token:'
  end

  it 'with invalid callback url' do
    create_api_app('test app', 'http://localhost', 'callback')
    expect(page).to have_content 'callback is not a valid URL'
    expect(page).not_to have_content 'API Token:'
  end
end
