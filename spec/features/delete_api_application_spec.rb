require 'rails_helper'

describe 'Delete an API Application' do
  before do
    user = create(:user_with_app)
    login_as(user, scope: :user)
    name = user.api_applications.first.name
    main_url = user.api_applications.first.main_url
    visit_app(name, main_url)
  end

  it 'deletes the application when the delete button is clicked' do
    click_link I18n.t('buttons.delete_application')

    expect(page).to have_content 'Application was successfully deleted.'
    expect(page).to have_current_path api_applications_path, ignore_query: true
  end
end
