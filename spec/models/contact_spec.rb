require 'spec_helper'

describe Contact do

  subject { build(:contact) }

  it { should be_valid }

  describe "invalid data" do
    before(:each) { @attrs = {} }

    # context "without a name" do
    #   subject { build(:contact, name: @attrs) }
    #   it { should_not be_valid }
    # end

    # context "without a title" do
    #   subject { build(:contact, title: @attrs) }
    #   it { should_not be_valid }
    # end

    context "email without period" do
      subject { build(:contact, email: "moncef@blahcom") }
      it { should_not be_valid }
    end

    context "email without @" do
      subject { build(:contact, email: "moncef.blahcom") }
      it { should_not be_valid }
    end

    context "phone number is less than 10 digits" do
      subject { build(:contact, phone: "123456789") }
      it { should_not be_valid }
    end

    context "fax number is less than 10 digits" do
      subject { build(:contact, fax: "123456789") }
      it { should_not be_valid }
    end
  end

  describe "valid data" do
    context "email with trailing whitespace" do
      subject { build(:contact, email: "moncef@blah.com ") }
      it { should be_valid }
    end

    context "with US phone containing dots" do
      subject { build(:contact, phone: "123.456.7890") }
      it { should be_valid }
    end

    context "with fax containing dashes and parens" do
      subject { build(:contact, fax: "(123)456-7890") }
      it { should be_valid }
    end
  end
end
