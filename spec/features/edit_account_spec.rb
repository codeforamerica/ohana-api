require 'rails_helper'

feature 'Editing User account' do
  before :each do
    login_user
    visit edit_user_registration_path
  end

  it 'allows the name to be changed' do
    fill_in 'user_name', with: 'New User name'
    fill_in 'user_current_password', with: @user.password
    click_button 'Update'
    visit edit_user_registration_path
    expect(find_field('user_name').value).to eq 'New User name'
  end

  it 'redirects to the user edit page after update' do
    fill_in 'user_name', with: 'New user name'
    fill_in 'user_current_password', with: @user.password
    click_button 'Update'
    expect(current_path).to eq edit_user_registration_path
  end
end
