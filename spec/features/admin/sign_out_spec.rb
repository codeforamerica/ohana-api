require 'rails_helper'

feature 'Signing out' do
  include Warden::Test::Helpers

  background do
    Warden.test_mode!
    login_admin
    visit edit_admin_registration_path
  end

  after(:each) do
    Warden.test_reset!
  end

  it 'redirects to the admin home page' do
    click_link 'Sign out'
    expect(current_path).to eq(admin_dashboard_path)
  end
end
