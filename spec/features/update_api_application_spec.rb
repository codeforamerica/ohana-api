feature "Update an existing API Application" do
  # The 'sign_in_and_create_app' and 'update_api_app' methods are defined in
  # spec/support/features/session_helpers.rb
  # All other methods are part of the Capybara DSL
  # https://github.com/jnicklas/capybara
  background do
    sign_in_and_create_app("test app", "http://localhost", "http://callback")
  end

  scenario "with valid fields" do
    update_api_app("my awesome app", "http://localhost", "http://callback")
    expect(page).to have_content "Application was successfully updated."
    expect(page).to have_content "Access Token"
  end

  scenario "with blank fields" do
    update_api_app("", "", "")
    expect(page).to have_content "Name can't be blank"
    expect(page).to have_content "Main url can't be blank"
    expect(page).to have_content "Callback url can't be blank"
    expect(page).to have_button "Update application"
    expect(page).to have_content "Access Token"
  end
end