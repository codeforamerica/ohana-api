require 'rails_helper'

feature 'Visit home page after signing in' do
  include Warden::Test::Helpers
  # The 'login_as' method is a Warden test helper that
  # allows you to simulate a user login without having
  # to fill in the sign in form every time. Since we're
  # not testing the signing in part of the app here, we
  # can take advantage of the Warden helper and speed up
  # our integration tests.

  # All other methods are part of the Capybara DSL
  # https://github.com/jnicklas/capybara
  background do
    Warden.test_mode!
    user = FactoryGirl.create(:user)
    login_as(user, scope: :user)
    visit '/'
  end

  after(:each) do
    Warden.test_reset!
  end

  scenario "click 'create a new application' link" do
    click_link 'Create a new application'
    expect(page).to have_content 'Register a new application'
  end

  scenario "click 'view' link" do
    click_link 'view'
    expect(page).to have_content 'Developer Applications'
  end
end
