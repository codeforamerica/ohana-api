require 'rails_helper'

describe Admin do
  def admin_attrs
    {
      name: 'Example User',
      email: 'user@example.com',
      password: 'changeme',
      password_confirmation: 'changeme'
    }
  end

  subject { build(:admin, admin_attrs) }

  it do
    expect(subject).to have_db_column(:name).of_type(:string).with_options(default: '')
  end

  it do
    expect(subject).to have_db_column(:encrypted_password).of_type(:string).
      with_options(default: '')
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }

  it { is_expected.to validate_length_of(:password).is_at_least(8) }

  it do
    expect(subject).to allow_value(
      'user@foo.com',
      'THE_USER@foo.bar.org',
      'first.last@foo.jp'
    ).for(:email)
  end

  it do
    expect(subject).not_to allow_value(
      'user@foo,com',
      'user_at_foo.org',
      'example.user@foo.'
    ).for(:email)
  end

  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  it 'rejects email addresses identical up to case' do
    upcased_email = admin_attrs[:email].upcase
    Admin.create!(admin_attrs.merge(email: upcased_email))
    user_with_duplicate_email = Admin.new(admin_attrs)

    expect(user_with_duplicate_email).not_to be_valid
  end

  describe 'password validations' do
    it 'requires a matching password confirmation' do
      expect(Admin.new(admin_attrs.merge(password_confirmation: 'invalid'))).
        not_to be_valid
    end
  end

  describe 'password encryption' do
    it 'sets the encrypted password attribute' do
      user = Admin.create!(admin_attrs)

      expect(user.encrypted_password).not_to be_blank
    end
  end
end
