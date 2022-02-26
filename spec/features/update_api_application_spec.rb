require 'rails_helper'

describe 'Update an existing API Application' do
  # The 'visit_app' and 'update_api_app' methods are defined in
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
    user = create(:user_with_app)
    login_as(user, scope: :user)
    name = user.api_applications.first.name
    main_url = user.api_applications.first.main_url
    visit_app(name, main_url)
  end

  it 'with valid fields' do
    update_api_app('my awesome app', 'http://cfa.org', 'http://cfa.org')
    expect(page).to have_content 'Application was successfully updated.'
    expect(page).to have_content 'API Token'
    expect(page).to have_current_path edit_api_application_path(ApiApplication.last.id),
                                      ignore_query: true
  end

  it 'with blank fields' do
    update_api_app('', '', '')
    expect(page).to have_content "Name can't be blank"
    expect(page).to have_content "Main URL can't be blank"
    expect(page).to have_button I18n.t('buttons.update_application')
    expect(page).to have_content 'API Token'
  end
end
