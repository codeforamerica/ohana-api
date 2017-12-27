require 'rails_helper'
# Uses the nifty shoulda-matchers
# https://github.com/thoughtbot/shoulda-matchers
describe User do
  subject(:user) { build_stubbed(:user) }

  it { is_expected.to be_valid }

  it { is_expected.to have_many :api_applications }

  it do
    is_expected.to have_db_column(:name).of_type(:string).with_options(default: '')
  end

  it do
    is_expected.to have_db_column(:encrypted_password).of_type(:string).
      with_options(default: '')
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }

  it { is_expected.to validate_length_of(:password).is_at_least(8) }

  it do
    is_expected.to allow_value(
      'user@foo.com',
      'THE_USER@foo.bar.org',
      'first.last@foo.jp'
    ).for(:email)
  end

  it do
    is_expected.not_to allow_value(
      'user@foo,com',
      'user_at_foo.org',
      'example.user@foo.'
    ).for(:email)
  end

  it 'validates uniqueness of email' do
    user = build(:user)
    expect(user).to validate_uniqueness_of(:email).case_insensitive
  end

  describe 'password validations' do
    it 'requires a matching password confirmation' do
      expect(build_stubbed(:user, password_confirmation: 'invalid')).
        not_to be_valid
    end
  end

  describe 'password encryption' do
    it 'should set the encrypted password attribute' do
      user = build_stubbed(:user)
      expect(user.encrypted_password).not_to be_blank
    end
  end
end
