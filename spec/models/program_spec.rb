require 'spec_helper'

describe Program do

  subject { build(:program) }

  it { should be_valid }
  describe "invalidations" do
    context "without a name" do
      subject { build(:program, name: nil)}
      it { should_not be_valid }
    end

    context "without a description" do
      subject { build(:program, description: nil)}
      it { should_not be_valid }
    end

    context "with URL containing 3 slashes" do
      subject { build(:program, urls: ["http:///codeforamerica.org"]) }
      it { should_not be_valid }
    end

    context "with URL missing a period" do
      subject { build(:program, urls: ["http://codeforamericaorg"]) }
      it { should_not be_valid }
    end

    context "URL with wwww" do
      subject { build(:program, urls: ["http://wwww.codeforamerica.org"]) }
      it { should be_valid }
    end

    context "URL without protocol" do
      subject { build(:program, urls: ["www.codeforamerica.org"]) }
      it { should_not be_valid }
    end

    context "URL with trailing whitespace" do
      subject { build(:program, urls: ["http://www.codeforamerica.org "]) }
      it { should_not be_valid }
    end

    context "non-US URL" do
      subject { build(:program, urls: ["http://www.monfresh.com.au"]) }
      it { should be_valid }
    end

    context "URL with capitalizations" do
      subject { build(:program, urls: ["HTTP://WWW.monfresh.com.au"]) }
      it { should be_valid }
    end

    it { should normalize_attribute(:urls).
      from(" http://www.codeforamerica.org  ").
      to("http://www.codeforamerica.org") }
  end
end
