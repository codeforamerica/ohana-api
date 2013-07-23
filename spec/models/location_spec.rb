require 'spec_helper'

describe Location do

  subject { build(:location) }

  it { should be_valid }

  it { should respond_to(:address) }
  its(:address) { should == "#{subject.street}, #{subject.city}, #{subject.state} #{subject.zipcode}" }


  describe "invalidations" do
    context "without a name" do
      subject { build(:location, name: nil)}
      it { should_not be_valid }
    end

    context "without a city" do
      subject { build(:location, city: nil)}
      it { should_not be_valid }
    end

    context "without a zipcode" do
      subject { build(:location, zipcode: nil)}
      it { should_not be_valid }
    end

    context "with a zipcode less than 5 characters" do
      subject { build(:location, zipcode: "1234") }
      it { should_not be_valid }
    end

    context "with a zipcode that has 6 consecutive digits" do
      subject { build(:location, zipcode: "123456") }
      it { should_not be_valid }
    end

    context "with a zipcode that has too few digits after the dash" do
      subject { build(:location, zipcode: "12345-689") }
      it { should_not be_valid }
    end

    context "with a zipcode greater than 10 characters" do
      subject { build(:location, zipcode: "90210-90210") }
      it { should_not be_valid }
    end

    context "with a 5 + 4 zipcode" do
      subject { build(:location, zipcode: "90210-1234") }
      it { should be_valid }
    end

    context "with a non-US phone" do
      subject { build(:location,
                        phones: [[{ "number" => "33 6 65 08 51 12" }]]) }
      it { should_not be_valid }
    end

    context "with US phone containing dots" do
      subject { build(:location,
                        phones: [[{ "number" => "123.456.7890" }]]) }
      it { should be_valid }
    end

    context "with URL containing 3 slashes" do
      subject { build(:location, urls: ["http:///codeforamerica.org"]) }
      it { should be_valid }
    end

    context "with URL missing a period" do
      subject { build(:location, urls: ["http://codeforamericaorg"]) }
      it { should_not be_valid }
    end

    context "URL with wwww" do
      subject { build(:location, urls: ["http://wwww.codeforamerica.org"]) }
      it { should be_valid }
    end

    context "URL without protocol" do
      subject { build(:location, urls: ["www.codeforamerica.org"]) }
      it { should be_valid }
    end

    context "URL with trailing whitespace" do
      subject { build(:location, urls: ["www.codeforamerica.org "]) }
      it { should be_valid }
    end

    context "non-US URL" do
      subject { build(:location, urls: ["http://www.monfresh.com.au"]) }
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
