require 'spec_helper'
# Uses the nifty shoulda-matchers
# https://github.com/thoughtbot/shoulda-matchers
describe ApiApplication do
  it { should belong_to :user }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:main_url) }

  it { should validate_uniqueness_of(:name) }
  it { should validate_uniqueness_of(:api_token) }

  it { should_not allow_mass_assignment_of(:api_token) }

  it do
    should allow_value('http://cfa.org', 'https://github.com').
      for(:main_url)
  end

  it { should_not allow_value('http://').for(:main_url) }

  it { should_not allow_value('http://').for(:callback_url) }
end
