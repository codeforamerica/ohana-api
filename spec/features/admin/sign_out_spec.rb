require 'rails_helper'

describe 'Signing out' do
  before do
    login_admin
    visit edit_admin_registration_path
  end

  it 'redirects to the admin sign in page' do
    click_link I18n.t('navigation.sign_out')
    expect(page).to have_current_path(new_admin_session_path, ignore_query: true)
  end
end
