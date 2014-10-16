require 'rails_helper'

feature 'Visiting the Sign in page' do
  before :each do
    visit new_admin_session_path
  end

  it 'includes a link to the sign in page in the navigation' do
    within '.navbar' do
      expect(page).not_to have_link 'Sign in', href: new_admin_session_path
    end
  end

  it 'includes a link to the sign up page in the navigation' do
    within '.navbar' do
      expect(page).not_to have_link 'Sign up', href: new_admin_registration_path
    end
  end

  it 'does not include a link to the Docs page in the navigation' do
    within '.navbar' do
      expect(page).not_to have_link 'Docs'
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
      sign_in_admin(valid_admin.email, valid_admin.password)
    end

    it 'sets the current path to the admin root path' do
      expect(current_path).to eq(admin_dashboard_path)
    end

    it 'displays a success message' do
      expect(page).to have_content 'Signed in successfully'
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

    it 'includes a link to organizations in the navigation' do
      within '.navbar' do
        expect(page).to have_link 'Organizations', href: admin_organizations_path
      end
    end
  end

  scenario 'with invalid credentials' do
    sign_in_admin('hello@example.com', 'wrongpassword')
    expect(page).to have_content 'Invalid email or password'
  end

  scenario 'with an unconfirmed admin' do
    unconfirmed_admin = create(:unconfirmed_admin)
    sign_in_admin(unconfirmed_admin.email, unconfirmed_admin.password)
    expect(page)
      .to have_content 'You have to confirm your account before continuing.'
  end
end
