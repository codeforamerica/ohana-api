require 'rails_helper'

describe Event do
  subject { build(:event) }

  it { is_expected.to allow_mass_assignment_of(:title) }
  it { is_expected.to allow_mass_assignment_of(:posted_at) }
  it { is_expected.to allow_mass_assignment_of(:starting_at) }
  it { is_expected.to allow_mass_assignment_of(:ending_at) }
  it { is_expected.to allow_mass_assignment_of(:street_1) }
  it { is_expected.to allow_mass_assignment_of(:street_2) }
  it { is_expected.to allow_mass_assignment_of(:city) }
  it { is_expected.to allow_mass_assignment_of(:state_abbr) }
  it { is_expected.to allow_mass_assignment_of(:zip) }
  it { is_expected.to allow_mass_assignment_of(:phone) }
  it { is_expected.to allow_mass_assignment_of(:external_url) }
  it { is_expected.to allow_mass_assignment_of(:organization_id) }
  it { is_expected.to allow_mass_assignment_of(:is_featured) }
  it { is_expected.to allow_mass_assignment_of(:body) }
  it { is_expected.to allow_mass_assignment_of(:user_id) }

  it { is_expected.to belong_to(:admin) }
  it { is_expected.to belong_to(:organization) }
end
