require 'spec_helper'

describe Organization do

	subject { build(:full_org) }

	it { should be_valid }

	it { should respond_to(:address) }
	its(:address) { should == "#{subject.street_address}, #{subject.city}, #{subject.state} #{subject.zipcode}" }

	it { should respond_to(:market_match?) }
  its(:market_match?) { should be_true }

  context "does not participate in market match" do
	  subject { build(:org_without_market_match) }
	  its(:market_match?) { should be_false }
	end

	describe "invalidations" do
		context "without a name" do
	  	subject { build(:organization, name: nil)} 
	  	it { should_not be_valid }
		end

		context "with a zipcode less than 5 characters" do
	  	subject { build(:organization, zipcode: "1234") }
	  	it { should_not be_valid }
		end

		context "with a zipcode that has 6 consecutive digits" do
	  	subject { build(:organization, zipcode: "123456") }
	  	it { should_not be_valid }
		end

		context "with a zipcode that has too few digits after the dash" do
	  	subject { build(:organization, zipcode: "12345-689") }
	  	it { should_not be_valid }
		end

		context "with a zipcode greater than 10 characters" do
	  	subject { build(:organization, zipcode: "90210-90210") }
	  	it { should_not be_valid }
		end

		context "with a 5 + 4 zipcode" do
	  	subject { build(:organization, zipcode: "90210-1234") }
	  	it { should be_valid }
		end

		context "with a non-US phone" do
	  	subject { build(:organization, phone: "90210-90210") }
	  	it { should_not be_valid }
		end

		context "with US phone containing dots" do
	  	subject { build(:organization, phone: "123.456.7890") }
	  	it { should be_valid }
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
	  	subject { build(:organization, urls: ["http://www.colouredlines.com.au"]) }
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
