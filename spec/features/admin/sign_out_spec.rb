require 'rails_helper'

feature 'Signing out' do
  background do
    login_admin
    visit edit_admin_registration_path
  end

  it 'redirects to the admin home page' do
    click_link 'Sign out'
    expect(current_path).to eq(admin_dashboard_path)
  end
end
