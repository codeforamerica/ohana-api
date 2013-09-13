require 'spec_helper'

describe Address do

  subject { build(:mail_address) }

  it { should be_valid }

  describe "invalid data" do
    before(:each) do 
      @attrs = { street: "123", city: "belmont", state: "CA", zip: "90210" }
    end

    context "without a street address" do
      subject { build(:mail_address, @attrs.merge(street: nil)) }
      it { should_not be_valid }
    end

    context "without a city" do
      subject { build(:mail_address, @attrs.merge(city: nil)) }
      it { should_not be_valid }
    end

    context "without a state less than 2 characters" do
      subject { build(:mail_address, @attrs.merge(state: "C")) }
      it { should_not be_valid }
    end

    context "without a zipcode" do
      subject { build(:mail_address, @attrs.merge(zip: nil)) }
      it { should_not be_valid }
    end

    context "with a zipcode less than 5 characters" do
      subject { build(:mail_address, @attrs.merge(zip: "1234")) }
      it { should_not be_valid }
    end

    context "with a zipcode that has 6 consecutive digits" do
      subject { build(:mail_address, @attrs.merge(zip: "123456")) }
      it { should_not be_valid }
    end

    context "with a zipcode that has too few digits after the dash" do
      subject { build(:mail_address, @attrs.merge(zip: "12346-689")) }
      it { should_not be_valid }
    end

    context "with a zipcode greater than 10 characters" do
      subject { build(:mail_address, @attrs.merge(zip: "90210-90210")) }
      it { should_not be_valid }
    end

    context "with a 5 + 4 zipcode" do
      subject { build(:mail_address, @attrs.merge(zip: "90210-1234")) }
      it { should be_valid }
    end
  end
end
