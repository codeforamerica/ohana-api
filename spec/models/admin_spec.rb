require 'spec_helper'
require "cancan/matchers"

# Uses the nifty mongoid-rspec matchers
# https://github.com/evansagge/mongoid-rspec
describe Admin do

  before(:each) do
    @attr = {
      :email => "user@example.com",
      :password => "changeme",
      :password_confirmation => "changeme"
    }
  end

  it "creates a new instance given a valid attribute" do
    Admin.create!(@attr)
  end

  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:password) }
  it { should allow_mass_assignment_of(:password_confirmation) }
  it { should allow_mass_assignment_of(:remember_me) }

  it { should have_field(:encrypted_password).of_type(String)
                                             .with_default_value_of("") }

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
    Admin.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = Admin.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "password validations" do

    it "requires a matching password confirmation" do
      Admin.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end
  end

  describe "password encryption" do

    before(:each) do
      @user = Admin.create!(@attr)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end
  end

  describe "abilities" do
    subject { ability }
    let(:ability){ Ability.new(user) }
    let(:user){ nil }

    context "when is an admin" do
      let(:user){ FactoryGirl.create(:admin) }

      it{ should be_able_to(:manage, User.new) }
      it{ should be_able_to(:manage, Admin.new) }
      it{ should be_able_to(:manage, Organization.new) }
      it{ should be_able_to(:manage, Service.new) }
      it{ should be_able_to(:manage, Location.new) }
    end

    context "when is an editor" do
      let(:user){ FactoryGirl.create(:admin_editor) }

      it{ should_not be_able_to(:manage, User.new) }
      it{ should_not be_able_to(:manage, Admin.new) }
      it{ should be_able_to(:create, Location.new) }
      it{ should be_able_to(:create, Organization.new) }
      it{ should be_able_to(:create, Service.new) }

      it{ should be_able_to(:update, Location.new) }
      it{ should be_able_to(:update, Organization.new) }
      it{ should be_able_to(:update, Service.new) }

      it{ should_not be_able_to(:destroy, Location.new) }
      it{ should_not be_able_to(:destroy, Organization.new) }
      it{ should_not be_able_to(:destroy, Service.new) }
    end
  end
end