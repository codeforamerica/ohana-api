require 'spec_helper'

describe Location do

  subject { build(:location) }

  it { should be_valid }

  # it { should respond_to(:find_by_keyword) }
  # its(:find_by_keyword) { should == "" }

  it { should respond_to(:full_address) }
  its(:full_address) { should == "#{subject.address.street}, " +
    "#{subject.address.city}, " + "#{subject.address.state} " +
    "#{subject.address.zip}" }

  describe "invalidations" do
    context "without an address" do
      subject { build(:no_address, address: {}) }
      it { should_not be_valid }
    end

    context "with a non-US phone" do
      subject { build(:location,
                        phones: [{ "number" => "33 6 65 08 51 12" }]) }
      it { should_not be_valid }
    end

    context "with US phone containing dots" do
      subject { build(:location,
                        phones: [{ "number" => "123.456.7890" }]) }
      it { should be_valid }
    end

    context "email without period" do
      subject { build(:location, emails: ["moncef@blahcom"]) }
      it { should_not be_valid }
    end

    context "email without @" do
      subject { build(:location, emails: ["moncef.blahcom"]) }
      it { should_not be_valid }
    end

    context "email with trailing whitespace" do
      subject { build(:location, emails: ["moncef@blah.com "]) }
      it { should be_valid }
    end
  end
end
