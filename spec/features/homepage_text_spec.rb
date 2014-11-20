require 'rails_helper'

feature 'Visit home page after signing in' do
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
    visit '/'
  end

  it 'does not include a link to the Docs page in the navigation' do
    within '.navbar' do
      expect(page).to_not have_link 'Docs'
    end
  end

  it 'includes a link to the dev portal home page in the navigation' do
    within '.navbar' do
      expect(page).to have_link 'Ohana API Developers', href: root_path
    end
  end

  it 'includes a link to sign out in the navigation' do
    within '.navbar' do
      expect(page).
        to have_link 'Sign out', href: destroy_user_session_path
    end
  end

  it 'includes a link to the Edit Account page in the navigation' do
    within '.navbar' do
      expect(page).
        to have_link 'Edit account', href: edit_user_registration_path
    end
  end

  scenario "click 'Register a new application' link" do
    click_link 'Register a new application'
    expect(page).to have_content 'Register a new application'
  end

  scenario "click 'view' link" do
    click_link 'view'
    expect(page).to have_content 'Developer Applications'
  end
end
