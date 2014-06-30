require 'rails_helper'

feature 'Signing out' do
  include Warden::Test::Helpers

  background do
    Warden.test_mode!
    login_user
    visit edit_user_registration_path
  end

  after(:each) do
    Warden.test_reset!
  end

  it 'redirects to the user home page' do
    click_link 'Sign out'
    expect(current_path).to eq(root_path)
  end
end
