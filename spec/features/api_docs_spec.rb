require 'spec_helper'

describe 'Visit api/docs' do

  it 'displays an Overview' do
    visit '/api/docs'
    expect(page).to have_content 'Overview'
  end
end
