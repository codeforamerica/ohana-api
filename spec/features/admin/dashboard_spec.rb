require 'rails_helper'

feature 'Admin Home page' do
  context 'when not signed in' do
    before :each do
      visit '/admin'
    end

    it 'sets the current path to the admin root page' do
      expect(current_path).to eq(admin_dashboard_path)
    end

    it 'prompts the user to sign in or sign up' do
      expect(page).to have_content 'please sign in, or sign up'
    end

    it 'includes a link to the sign in page' do
      within '#main' do
        expect(page).to have_link 'sign in', href: new_admin_session_path
      end
    end

    it 'includes a link to the sign up page' do
      within '#main' do
        expect(page).to have_link 'sign up', href: new_admin_registration_path
      end
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

    it 'does not include a link to the Home page in the navigation' do
      within '.navbar' do
        expect(page).not_to have_link 'Home', href: root_path
      end
    end

    it 'does not include a link to Your locations in the navigation' do
      within '.navbar' do
        expect(page).not_to have_link 'Your locations', href: admin_locations_path
      end
    end
  end

  context 'when signed in' do
    before :each do
      login_admin
      visit '/admin'
    end

    it 'greets the admin by their name' do
      expect(page).to have_content 'Welcome back, Org Admin!'
    end

    it 'does not include a link to the sign up page in the navigation' do
      within '.navbar' do
        expect(page).not_to have_link 'Sign up'
      end
    end

    it 'does not include a link to the sign in page in the navigation' do
      within '.navbar' do
        expect(page).not_to have_link 'Sign in'
      end
    end

    it 'includes a link to sign out in the navigation' do
      within '.navbar' do
        expect(page).
          to have_link 'Sign out', href: destroy_admin_session_path
      end
    end

    it 'includes a link to the Edit Account page in the navigation' do
      within '.navbar' do
        expect(page).
          to have_link 'Edit account', href: edit_admin_registration_path
      end
    end

    it 'displays the name of the logged in admin in the navigation' do
      within '.navbar' do
        expect(page).to have_content "Logged in as #{@admin.name}"
      end
    end

    it 'includes a link to Your locations in the navigation' do
      within '.navbar' do
        expect(page).to have_link 'Your locations', href: admin_locations_path
      end
    end
  end
end
