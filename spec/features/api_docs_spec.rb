require 'rails_helper'

describe 'Visit /docs' do

  it 'displays an Overview' do
    visit docs_url(subdomain: ENV['DEV_SUBDOMAIN'])
    expect(page).to have_content 'Overview'
  end
end
