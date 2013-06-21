feature "Creating a new API Application" do
  # The 'sign_in' and 'create_api_app' methods are defined in
  # spec/support/features/session_helpers.rb
  # All other methods are part of the Capybara DSL
  # https://github.com/jnicklas/capybara
  background do
    valid_user = FactoryGirl.create(:user)
    sign_in(valid_user.email, valid_user.password)
  end

  scenario "visit apps with no apps created" do
    click_link "Your apps"
    expect(page).to_not have_content 'http'
  end

  scenario "with valid fields" do
    create_api_app("my awesome app", "http://localhost", "http://callback")
    expect(page).to have_content "Application was successfully created."
    expect(page).to_not have_content "Access token is already taken"
    expect(page.text).to match(/Access Token: \w+/)
  end

  scenario "with blank fields" do
    create_api_app("", "", "")
    expect(page).to have_content "Name can't be blank"
    expect(page).to have_content "Main url can't be blank"
    expect(page).to have_content "Callback url can't be blank"
    expect(page).to_not have_content "Access Token:"
  end

  scenario "with invalid main url" do
    create_api_app("test app", "ohana", "http://callback")
    expect(page).to have_content "Please include the protocol"
    expect(page).to_not have_content "Access Token:"
  end

  scenario "with invalid callback url" do
    create_api_app("test app", "http://localhost", "callback")
    expect(page).to have_content "Please include the protocol"
    expect(page).to_not have_content "Access Token:"
  end

end