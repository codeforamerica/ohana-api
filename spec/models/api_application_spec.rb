require 'rails_helper'
# Uses the nifty shoulda-matchers
# https://github.com/thoughtbot/shoulda-matchers
describe ApiApplication do
  it { is_expected.not_to allow_mass_assignment_of(:api_token) }
  it { is_expected.to allow_mass_assignment_of(:name) }
  it { is_expected.to allow_mass_assignment_of(:main_url) }
  it { is_expected.to allow_mass_assignment_of(:callback_url) }

  it { is_expected.to belong_to :user }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:main_url) }

  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_uniqueness_of(:api_token) }

  it { is_expected.not_to allow_mass_assignment_of(:api_token) }

  it do
    is_expected.to allow_value('http://cfa.org', 'https://github.com').
      for(:main_url)
  end

  it do
    is_expected.not_to allow_value('http://').for(:main_url).
      with_message('http:// is not a valid URL')
  end

  it do
    is_expected.not_to allow_value('http://foo').for(:callback_url).
      with_message('http://foo is not a valid URL')
  end

  describe 'auto_strip_attributes' do
    it 'strips extra whitespace before validation' do
      app = build(:app_with_extra_whitespace)
      app.valid?
      expect(app.name).to eq('app with extra whitespace')
    end
  end
end
