require 'spec_helper'

describe Organization do

  subject { build(:organization) }

  it { should be_valid }

  describe "invalidations" do
    context "without a name" do
      subject { build(:organization, name: nil)}
      it { should_not be_valid }
    end

    context "with URL containing 3 slashes" do
      subject { build(:organization, urls: ["http:///codeforamerica.org"]) }
      it { should be_valid }
    end

    context "with URL missing a period" do
      subject { build(:organization, urls: ["http://codeforamericaorg"]) }
      it { should_not be_valid }
    end

    context "URL with wwww" do
      subject { build(:organization, urls: ["http://wwww.codeforamerica.org"]) }
      it { should be_valid }
    end

    context "URL without protocol" do
      subject { build(:organization, urls: ["www.codeforamerica.org"]) }
      it { should be_valid }
    end

    context "URL with trailing whitespace" do
      subject { build(:organization, urls: ["www.codeforamerica.org "]) }
      it { should be_valid }
    end

    context "non-US URL" do
      subject { build(:organization, urls: ["http://www.monfresh.com.au"]) }
      it { should be_valid }
    end

    context "email without period" do
      subject { build(:organization, emails: ["moncef@blahcom"]) }
      it { should_not be_valid }
    end

    context "email without @" do
      subject { build(:organization, emails: ["moncef.blahcom"]) }
      it { should_not be_valid }
    end

    context "email with trailing whitespace" do
      subject { build(:organization, emails: ["moncef@blah.com "]) }
      it { should be_valid }
    end
  end
end
