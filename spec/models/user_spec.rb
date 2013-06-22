require 'spec_helper'
# Uses the nifty mongoid-rspec matchers
# https://github.com/evansagge/mongoid-rspec
describe User do

  before(:each) do
    @attr = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "changeme",
      :password_confirmation => "changeme"
    }
  end

  it "creates a new instance given a valid attribute" do
    User.create!(@attr)
  end

  it { should embed_many :api_applications }

  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:password) }
  it { should allow_mass_assignment_of(:password_confirmation) }
  it { should allow_mass_assignment_of(:remember_me) }

  it { should have_field(:name).of_type(String).with_default_value_of("") }
  it { should have_field(:encrypted_password).of_type(String)
                                             .with_default_value_of("") }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  it { should validate_length_of(:password).greater_than(8) }

  it { should validate_format_of(:email).to_allow("user@foo.com")
                                        .not_to_allow("user@foo,com") }

  it { should validate_format_of(:email).to_allow("THE_USER@foo.bar.org")
                                        .not_to_allow("user_at_foo.org") }

  it { should validate_format_of(:email).to_allow("first.last@foo.jp")
                                        .not_to_allow("example.user@foo.") }

  it { should validate_uniqueness_of(:email) }

  it "rejects email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "password validations" do

    it "requires a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end
  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end
  end
end