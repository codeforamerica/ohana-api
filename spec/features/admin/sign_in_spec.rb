require 'rails_helper'

describe 'Visiting the Sign in page' do
  before do
    visit new_admin_session_path
  end

  it 'includes a link to the sign in page in the navigation' do
    within '.navbar' do
      expect(page).not_to have_link I18n.t('navigation.sign_in'), href: new_admin_session_path
    end
  end

  it 'includes a link to the sign up page in the navigation' do
    within '.navbar' do
      expect(page).not_to have_link I18n.t('navigation.sign_in'), href: new_admin_registration_path
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

describe 'Signing in' do
  context 'with correct credentials' do
    before do
      valid_admin = create(:admin)
      sign_in_admin(valid_admin.email, valid_admin.password)
    end

    it 'sets the current path to the admin root path' do
      expect(page).to have_current_path(admin_dashboard_path, ignore_query: true)
    end

    it 'displays a success message' do
      expect(page).to have_content 'Signed in successfully'
    end

    it 'does not include a link to the sign up page in the navigation' do
      within '.navbar' do
        expect(page).not_to have_link I18n.t('navigation.sign_up')
      end
    end

    it 'does not include a link to the sign in page in the navigation' do
      within '.navbar' do
        expect(page).not_to have_link I18n.t('navigation.sign_in')
      end
    end

    it 'includes a link to sign out in the navigation' do
      within '.navbar' do
        expect(page).
          to have_link I18n.t('navigation.sign_out'), href: destroy_admin_session_path
      end
    end

    it 'includes a link to the Edit Account page in the navigation' do
      within '.navbar' do
        expect(page).
          to have_link I18n.t('navigation.edit_account'), href: edit_admin_registration_path
      end
    end

    it 'includes a link to organizations in the navigation' do
      within '.navbar' do
        expect(page).to have_link 'Organizations', href: admin_organizations_path
      end
    end
  end

  it 'with invalid credentials' do
    sign_in_admin('hello@example.com', 'wrongpassword')
    expect(page).to have_content 'Invalid email or password'
  end

  it 'with an unconfirmed admin' do
    unconfirmed_admin = create(:unconfirmed_admin)
    sign_in_admin(unconfirmed_admin.email, unconfirmed_admin.password)
    expect(page).
      to have_content 'You have to confirm your account before continuing.'
  end
end
