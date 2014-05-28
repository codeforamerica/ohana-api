require 'spec_helper'

feature 'Signing in' do
  # The 'sign_in' method is defined in spec/support/features/session_helpers.rb
  scenario 'with correct credentials' do
    valid_user = FactoryGirl.create(:user)
    sign_in(valid_user.email, valid_user.password)
    expect(page).to have_content 'Welcome back Test User'
    expect(page).to have_content 'Signed in successfully'
  end

  scenario 'with invalid credentials' do
    sign_in('hello@example.com', 'wrongpassword')
    expect(page).to have_content 'Invalid email or password'
  end

  scenario 'with an unconfirmed user' do
    unconfirmed_user = FactoryGirl.create(:unconfirmed_user)
    sign_in(unconfirmed_user.email, unconfirmed_user.password)
    expect(page)
      .to have_content 'You have to confirm your account before continuing.'
  end
end
