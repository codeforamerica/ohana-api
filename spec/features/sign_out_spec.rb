require 'rails_helper'

describe 'Signing out' do
  before do
    login_user
    visit edit_user_registration_path
  end

  it 'redirects to the user home page' do
    click_link I18n.t('navigation.sign_out')
    expect(page).to have_current_path(root_path, ignore_query: true)
  end
end
