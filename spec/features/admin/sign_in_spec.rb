require 'rails_helper'

feature 'Visiting the Sign in page' do
  before :each do
    visit '/admin/sign_in'
  end

  it 'includes a link to the sign in page in the navigation' do
    within '.navbar' do
      expect(page).to have_link 'Sign in', href: new_admin_session_path
    end
  end

  it 'includes a link to the sign up page in the navigation' do
    within '.navbar' do
      expect(page).to have_link 'Sign up', href: new_admin_registration_path
    end
  end

  it 'does not include a link to the Docs page in the navigation' do
    within '.navbar' do
      expect(page).not_to have_link 'Docs', href: docs_path
    end
  end

  it 'does not include a link to the Home page in the navigation' do
    within '.navbar' do
      expect(page).not_to have_link 'Home', href: root_path
    end
  end
end

feature 'Signing in' do
  context 'with correct credentials' do
    before :each do
      valid_admin = create(:admin)
      visit '/admin/sign_in'
      within('#new_admin') do
        fill_in 'admin_email',    with: valid_admin.email
        fill_in 'admin_password', with: valid_admin.password
      end
      click_button 'Sign in'
    end

    it 'sets the current path to the admin root page' do
      expect(current_path).to eq(admin_dashboard_path)
    end

    xit "displays the admin's locations" do
      expect(page).to have_content 'Below you should see a list'
      expect(page).to have_content 'Samaritan House locations'
    end

    it 'greets the admin by their name' do
      expect(page).to have_content 'Welcome back, Test Admin!'
    end

    it 'displays a success message' do
      expect(page).to have_content 'Signed in successfully'
    end
  end

  scenario 'with invalid credentials' do
    sign_in('hello@example.com', 'wrongpassword')
    expect(page).to have_content 'Invalid email or password'
  end

  scenario 'with an unconfirmed user' do
    unconfirmed_user = create(:unconfirmed_user)
    sign_in(unconfirmed_user.email, unconfirmed_user.password)
    expect(page)
      .to have_content 'You have to confirm your account before continuing.'
  end
end
