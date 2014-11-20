require 'rails_helper'

feature 'Programs page' do
  context 'when not signed in' do
    before :each do
      visit '/admin/programs'
    end

    it 'redirects to the admin sign in page' do
      expect(current_path).to eq(new_admin_session_path)
    end

    it 'prompts the user to sign in or sign up' do
      expect(page).
        to have_content 'You need to sign in or sign up before continuing.'
    end

    it 'does not include a link to programs in the navigation' do
      within '.navbar' do
        expect(page).not_to have_link 'programs', href: admin_programs_path
      end
    end
  end

  context 'when signed in' do
    before :each do
      login_admin
      visit '/admin/programs'
    end

    it 'displays instructions for editing programs' do
      expect(page).to have_content 'Below you should see a list of programs'
      expect(page).to have_content 'To start updating, click on one of the links'
      expect(page).not_to have_content 'As a super admin'
    end

    it 'only shows links that belong to the admin' do
      nearby = create(:nearby_loc)
      nearby.organization.programs.
        create!(attributes_for(:program).merge(name: 'Nearby Program'))

      loc = create(:location_for_org_admin)
      loc.organization.programs.create!(attributes_for(:program))

      visit '/admin/programs'
      expect(page).not_to have_link 'Nearby Program'
      expect(page).to have_link 'Collection of Services'
    end
  end

  context 'when signed in as super admin' do
    before :each do
      nearby = create(:nearby_loc)
      @program = nearby.organization.programs.
                 create!(attributes_for(:program).
                 merge(name: 'Nearby Program'))

      loc = create(:location_for_org_admin)
      loc.organization.programs.create!(attributes_for(:program))

      login_super_admin
      visit '/admin/programs'
    end

    it 'displays instructions for editing programs' do
      expect(page).to have_content 'As a super admin'
    end

    it 'shows all programs' do
      expect(page).to have_link 'Nearby Program'
      expect(page).to have_link 'Collection of Services'
    end

    it 'takes you to the right program when clicked' do
      click_link 'Nearby Program'
      expect(current_path).to eq edit_admin_program_path(@program)
    end
  end
end
