require 'spec_helper'

describe Phone do

  subject { build(:phone) }

  it { should be_valid }

  it { should belong_to :location }

  it { should allow_mass_assignment_of(:number) }
  it { should allow_mass_assignment_of(:extension) }
  it { should allow_mass_assignment_of(:department) }
  it { should allow_mass_assignment_of(:vanity_number) }

  it { should normalize_attribute(:number).
    from(" 703 555-1212  ").to("703 555-1212") }

  it { should normalize_attribute(:extension).
    from(" x5104  ").to("x5104") }

  it { should normalize_attribute(:department).
    from(" Intake  ").to("Intake") }

  it { should normalize_attribute(:vanity_number).
    from(" 800 YOU-NEED  ").to("800 YOU-NEED") }

  describe "with invalid data" do
    context "without a number" do
      subject { build(:phone, number: nil)}
      it { should_not be_valid }
    end

    context "with an empty number" do
      subject { build(:phone, number: "")}
      it { should_not be_valid }
    end

    context "with a non-US phone" do
      subject { build(:phone, number: "33 6 65 08 51 12") }
      it { should_not be_valid }
    end
  end

  describe "valid data" do
    context "with US phone containing dots" do
      subject { build(:phone, number: "123.456.7890") }
      it { should be_valid }
    end
  end
end
