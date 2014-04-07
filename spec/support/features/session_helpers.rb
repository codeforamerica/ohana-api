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

    def visit_app(name, main_url)
      visit('/api_applications')
      click_link "#{name} (#{main_url})"
    end

    def create_service
      @location = create(:location)
      @service = @location.services.create!(attributes_for(:service))
      @location.reload
      @location.index.refresh
    end
  end
end