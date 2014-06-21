require 'rails_helper'

describe 'Visit api/docs' do

  it 'displays an Overview' do
    visit docs_endpoint(path: '/docs')
    expect(page).to have_content 'Overview'
  end
end
