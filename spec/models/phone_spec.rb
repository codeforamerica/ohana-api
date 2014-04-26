require 'spec_helper'

describe Phone do

  subject { build(:phone) }

  it { should be_valid }

  it { should belong_to :location }

  it { should allow_mass_assignment_of(:number) }
  it { should allow_mass_assignment_of(:extension) }
  it { should allow_mass_assignment_of(:department) }
  it { should allow_mass_assignment_of(:vanity_number) }

  it do
    should normalize_attribute(:number).
      from(' 703 555-1212  ').to('703 555-1212')
  end

  it do
    should normalize_attribute(:extension).
      from(' x5104  ').to('x5104')
  end

  it do
    should normalize_attribute(:department).
      from(' Intake  ').to('Intake')
  end

  it do
    should normalize_attribute(:vanity_number).
      from(' 800 YOU-NEED  ').to('800 YOU-NEED')
  end

  it do
    should validate_presence_of(:number).
      with_message("can't be blank for Phone")
  end

  it do
    should allow_value('703-555-1212', '800.123.4567').for(:number)
  end

  it do
    should_not allow_value('703-').
      for(:number).
      with_message('703- is not a valid US phone number')
  end
end
