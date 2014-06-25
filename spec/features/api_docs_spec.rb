require 'rails_helper'

describe 'Visit /docs' do

  it 'displays an Overview' do
    visit docs_endpoint(path: '/docs')
    expect(page).to have_content 'Overview'
  end
end
