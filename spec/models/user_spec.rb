require 'rails_helper'
# Uses the nifty shoulda-matchers
# https://github.com/thoughtbot/shoulda-matchers
describe User do
  before(:each) do
    @attr = {
      name: 'Example User',
      email: 'user@example.com',
      password: 'changeme',
      password_confirmation: 'changeme'
    }
  end

  it 'creates a new instance given a valid attribute' do
    User.create!(@attr)
  end

  it { is_expected.to have_many :api_applications }

  it { is_expected.to allow_mass_assignment_of(:name) }
  it { is_expected.to allow_mass_assignment_of(:email) }
  it { is_expected.to allow_mass_assignment_of(:password) }
  it { is_expected.to allow_mass_assignment_of(:password_confirmation) }
  it { is_expected.to allow_mass_assignment_of(:remember_me) }

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

  it { is_expected.to ensure_length_of(:password).is_at_least(8) }

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

  it { is_expected.to validate_uniqueness_of(:email) }

  it 'rejects email addresses identical up to case' do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(email: upcased_email))
    user_with_duplicate_email = User.new(@attr)
    expect(user_with_duplicate_email).not_to be_valid
  end

  describe 'password validations' do
    it 'requires a matching password confirmation' do
      expect(User.new(@attr.merge(password_confirmation: 'invalid'))).
        not_to be_valid
    end
  end

  describe 'password encryption' do
    before(:each) do
      @user = User.create!(@attr)
    end

    it 'should set the encrypted password attribute' do
      expect(@user.encrypted_password).not_to be_blank
    end
  end
end
