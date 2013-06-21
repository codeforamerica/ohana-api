module Features
  module SessionHelpers
    def sign_in(email, password)
      visit '/users/sign_in'
      within("#new_user") do
        fill_in 'Email', :with => email
        fill_in 'Password', :with => password
      end
      click_button 'Sign in'
    end

    def create_api_app(name, main_url, callback_url)
      click_link "Your apps"
      click_link "Register new application"
      within("#new_api_application") do
        fill_in 'Name',         :with => name
        fill_in 'Main URL',     :with => main_url
        fill_in 'Callback URL', :with => callback_url
      end
      click_button "Register application"
    end

    def update_api_app(name, main_url, callback_url)
      within(".edit_api_application") do
        fill_in 'Name',         :with => name
        fill_in 'Main URL',     :with => main_url
        fill_in 'Callback URL', :with => callback_url
      end
      click_button "Update application"
    end

    def sign_in_and_create_app(name, main_url, callback_url)
      valid_user = FactoryGirl.create(:user)
      sign_in(valid_user.email, valid_user.password)
      create_api_app(name, main_url, callback_url)
      click_link "Your apps"
      click_link "#{name} (#{main_url})"
    end
  end
end