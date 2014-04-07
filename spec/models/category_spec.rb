require 'spec_helper'

describe Category do
  subject { build(:category) }

  it { should be_valid }

  it { should have_and_belong_to_many(:services) }

  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:oe_id) }
end
