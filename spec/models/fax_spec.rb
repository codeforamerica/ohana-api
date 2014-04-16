require 'spec_helper'

describe Fax do
  subject { build(:fax) }

  it { should be_valid }

  it { should belong_to(:location) }

  it { should allow_mass_assignment_of(:number) }
  it { should allow_mass_assignment_of(:department) }

  it { should validate_presence_of(:number).
    with_message("can't be blank for Fax") }

  it { should normalize_attribute(:number).
    from(" 800-555-1212  ").
    to("800-555-1212") }

  it { should normalize_attribute(:department).
    from(" Youth Development  ").
    to("Youth Development") }

  it { should allow_value("703-555-1212", "800.123.4567").
    for(:number) }

  it do
    should_not allow_value("703-").
      for(:number).
      with_message('703- is not a valid US fax number')
  end
end
