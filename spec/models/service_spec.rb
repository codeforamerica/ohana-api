require 'spec_helper'

describe Service do
  subject { build(:service) }

  it { should be_valid }

  it { should belong_to(:location) }

  it { should have_and_belong_to_many(:categories) }

  it { should allow_mass_assignment_of(:audience) }
  it { should allow_mass_assignment_of(:description) }
  it { should allow_mass_assignment_of(:eligibility) }
  it { should allow_mass_assignment_of(:fees) }
  it { should allow_mass_assignment_of(:funding_sources) }
  it { should allow_mass_assignment_of(:keywords) }
  it { should allow_mass_assignment_of(:how_to_apply) }
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:service_areas) }
  it { should allow_mass_assignment_of(:short_desc) }
  it { should allow_mass_assignment_of(:urls) }
  it { should allow_mass_assignment_of(:wait) }

  it do
    should normalize_attribute(:audience).from(' youth  ').to('youth')
  end

  it do
    should normalize_attribute(:description).from(' Youth Development  ').
      to('Youth Development')
  end

  it do
    should normalize_attribute(:eligibility).from(' Youth Development  ').
      to('Youth Development')
  end

  it do
    should normalize_attribute(:fees).from(' Youth Development  ').
      to('Youth Development')
  end

  it do
    should normalize_attribute(:how_to_apply).from(' Youth Development  ').
      to('Youth Development')
  end

  it do
    should normalize_attribute(:name).from(' Youth Development  ').
      to('Youth Development')
  end

  it do
    should normalize_attribute(:short_desc).from(' Youth Development  ').
      to('Youth Development')
  end

  it do
    should normalize_attribute(:wait).from(' Youth Development  ').
      to('Youth Development')
  end

  it { should allow_value(['http://www.codeforamerica.org']).for(:urls) }

end
