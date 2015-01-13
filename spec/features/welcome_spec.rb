require 'rails_helper'

feature 'Upload data after creating a new app' do
  background do
    @token = FactoryGirl.create(:welcome_token)
  end

  scenario 'upload data and sign in' do
    pending

    visit welcome_path
    expect(page).to redirect_to welcome_path(code: @token.code)
    expect(page).to have_content 'Taxonomy'
    expect(page).to have_content 'Organizations'

    # attach_file('ok', File.absolute_path('./fileset/publisher/upload_pic.jpg'))
  end
end