require 'spec_helper'

describe Location do

  subject { build(:location) }

  it { should be_valid }

  it { should respond_to(:full_address) }
  its(:full_address) { should == "#{subject.address.street}, " +
    "#{subject.address.city}, " + "#{subject.address.state} " +
    "#{subject.address.zip}" }

  it { should respond_to(:full_physical_address) }
  its(:full_physical_address) { should == "#{subject.address.street}, " +
    "#{subject.address.city}, " + "#{subject.address.state} " +
    "#{subject.address.zip}" }

  it { should normalize_attribute(:urls).
    from(" http://www.codeforamerica.org  ").
    to("http://www.codeforamerica.org") }

  describe "invalidations" do
    context "without a name" do
      subject { build(:location, name: nil)}
      it { should_not be_valid }
    end

    context "with an empty name" do
      subject { build(:location, name: "")}
      it { should_not be_valid }
    end

    context "without a description" do
      subject { build(:location, description: nil)}
      it { should_not be_valid }
    end

    context "with URL containing 3 slashes" do
      subject { build(:location, urls: ["http:///codeforamerica.org"]) }
      it { should_not be_valid }
    end

    context "with URL missing a period" do
      subject { build(:location, urls: ["http://codeforamericaorg"]) }
      it { should_not be_valid }
    end

    context "URL without protocol" do
      subject { build(:location, urls: ["www.codeforamerica.org"]) }
      it { should_not be_valid }
    end

    context "URL with trailing whitespace" do
      subject { build(:location, urls: ["http://www.codeforamerica.org "]) }
      it { should_not be_valid }
    end

    context "without an address" do
      subject { build(:location, address: {}) }
      it { should_not be_valid }
    end

    context "with a non-US phone" do
      subject { build(:location,
                        phones: [{ "number" => "33 6 65 08 51 12" }]) }
      it { should_not be_valid }
    end

    context "email without period" do
      subject { build(:location, emails: ["moncef@blahcom"]) }
      it { should_not be_valid }
    end

    context "email without @" do
      subject { build(:location, emails: ["moncef.blahcom"]) }
      it { should_not be_valid }
    end
  end

  describe "valid data" do
    context "URL with wwww" do
      subject { build(:location, urls: ["http://wwww.codeforamerica.org"]) }
      it { should be_valid }
    end

    context "non-US URL" do
      subject { build(:location, urls: ["http://www.monfresh.com.au"]) }
      it { should be_valid }
    end

    context "URL with capitalizations" do
      subject { build(:location, urls: ["HTTP://WWW.monfresh.com.au"]) }
      it { should be_valid }
    end

    context "with US phone containing dots" do
      subject { build(:location,
                        phones: [{ "number" => "123.456.7890" }]) }
      it { should be_valid }
    end

    context "email with trailing whitespace" do
      subject { build(:location, emails: ["moncef@blah.com "]) }
      it { should be_valid }
    end

    context "without a description but is a Farmers' Market" do
      subject { build(:location, description: nil, market_match: 1)}
      it { should be_valid }
    end
  end
end
