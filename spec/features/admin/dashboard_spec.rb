require 'rails_helper'

feature 'Admin Home page' do
  context 'when not signed in' do
    before :each do
      visit '/admin'
    end

    it 'sets the current path to the admin sign in page' do
      expect(current_path).to eq(new_admin_session_path)
    end

    it 'includes a link to the sign up page' do
      within '#main' do
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
        expect(page).not_to have_link 'Locations', href: admin_locations_path
      end
    end

    it 'uses the admin layout' do
      within '.navbar' do
        expect(page).
          to have_content I18n.t('titles.admin', brand: I18n.t('titles.brand'))
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

    it 'includes a link to organizations in the body' do
      within '.content' do
        expect(page).
          to have_link 'Organizations', href: admin_organizations_path
      end
    end

    it 'includes a link to locations in the body' do
      within '.content' do
        expect(page).
          to have_link 'Locations', href: admin_locations_path
      end
    end

    it 'includes a link to services in the body' do
      within '.content' do
        expect(page).
          to have_link 'Services', href: admin_services_path
      end
    end

    it 'includes a link to programs in the body' do
      within '.content' do
        expect(page).
          to have_link 'Programs', href: admin_programs_path
      end
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
        expect(page).to have_content "Hi, #{@admin.name}"
      end
    end

    it 'includes a link to locations in the navigation' do
      within '.navbar' do
        expect(page).to have_link 'Locations', href: admin_locations_path
      end
    end

    it 'includes a link to organizations in the navigation' do
      within '.navbar' do
        expect(page).to have_link 'Organizations', href: admin_organizations_path
      end
    end

    it 'includes a link to services in the navigation' do
      within '.navbar' do
        expect(page).to have_link 'Services', href: admin_services_path
      end
    end

    it 'does not display a link to add a new organization' do
      expect(page).not_to have_link 'Add a new organization', new_admin_organization_path
    end

    it 'does not display a link to add a new location' do
      expect(page).to_not have_link 'Add a new location', new_admin_location_path
    end

    it 'does not display a link to add a new program' do
      expect(page).to_not have_link 'Add a new program', new_admin_program_path
    end
  end

  context 'when signed in as super admin and no orgs exist' do
    before :each do
      login_super_admin
      visit '/admin'
    end

    it 'displays a link to add a new organization' do
      expect(page).to have_link 'Add a new organization', new_admin_organization_path
    end

    it 'does not display a link to add a new location' do
      expect(page).to_not have_link 'Add a new location', new_admin_location_path
    end

    it 'does not display a link to add a new program' do
      expect(page).to_not have_link 'Add a new program', new_admin_program_path
    end
  end

  context 'when signed in as super admin and orgs exist' do
    before :each do
      create(:organization)
      login_super_admin
      visit '/admin'
    end

    it 'displays a link to add a new location' do
      expect(page).to have_link 'Add a new location', new_admin_location_path
    end

    it 'displays a link to add a new program' do
      expect(page).to have_link 'Add a new program', new_admin_program_path
    end
  end
end
