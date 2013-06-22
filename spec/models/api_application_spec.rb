require 'spec_helper'
# Uses the nifty mongoid-rspec matchers
# https://github.com/evansagge/mongoid-rspec
describe ApiApplication do
  it { should be_embedded_in :user }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:main_url) }
  it { should validate_presence_of(:callback_url) }

  it { should validate_uniqueness_of(:name) }
  it { should validate_uniqueness_of(:api_token) }

  it { should_not allow_mass_assignment_of(:api_token) }

  it { should validate_format_of(:main_url).to_allow("http://localhost")
                                           .not_to_allow("ohanapi.org") }
  it { should validate_format_of(:callback_url).to_allow("https://localhost")
                                               .not_to_allow("http://") }
end