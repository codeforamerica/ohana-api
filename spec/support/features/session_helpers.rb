module Features
  # Helper methods you can use in specs to perform common and
  # repetitive actions.
  module SessionHelpers
    def login_admin
      @admin = FactoryGirl.create(:admin)
      login_as(@admin, scope: :admin)
    end

    def login_user
      user = FactoryGirl.create(:user)
      login_as(user, scope: :user)
    end

    def sign_in(email, password)
      visit '/users/sign_in'
      within('#new_user') do
        fill_in 'Email',    with: email
        fill_in 'Password', with: password
      end
      click_button 'Sign in'
    end

    def sign_up(name, email, password, confirmation)
      visit '/users/sign_up'
      fill_in 'user_name',                  with: name
      fill_in 'user_email',                 with: email
      fill_in 'user_password',              with: password
      fill_in 'user_password_confirmation', with: confirmation
      click_button 'Sign up'
    end

    def sign_up_admin(name, email, password, confirmation)
      visit '/admin/sign_up'
      fill_in 'admin_name',                  with: name
      fill_in 'admin_email',                 with: email
      fill_in 'admin_password',              with: password
      fill_in 'admin_password_confirmation', with: confirmation
      click_button 'Sign up'
    end

    def create_api_app(name, main_url, callback_url)
      click_link 'Register new application'
      within('#new_api_application') do
        fill_in 'Name',         with: name
        fill_in 'Main URL',     with: main_url
        fill_in 'Callback URL', with: callback_url
      end
      click_button 'Register application'
    end

    def update_api_app(name, main_url, callback_url)
      within('.edit_api_application') do
        fill_in 'Name',         with: name
        fill_in 'Main URL',     with: main_url
        fill_in 'Callback URL', with: callback_url
      end
      click_button 'Update application'
    end

    def visit_app(name, main_url)
      visit('/api_applications')
      click_link "#{name} (#{main_url})"
    end
  end
end
