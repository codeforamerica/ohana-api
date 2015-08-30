require 'rails_helper'

feature 'Delete an API Application' do
  background do
    user = FactoryGirl.create(:user_with_app)
    login_as(user, scope: :user)
    name = user.api_applications.first.name
    main_url = user.api_applications.first.main_url
    visit_app(name, main_url)
  end

  it 'deletes the application when the delete button is clicked' do
    click_link I18n.t('buttons.delete_application')

    expect(page).to have_content 'Application was successfully deleted.'
    expect(current_path).to eq api_applications_path
  end
end
