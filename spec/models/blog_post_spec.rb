require 'rails_helper'

describe BlogPost do
  subject { build(:blog_post) }

  it { is_expected.to allow_mass_assignment_of(:title) }
  it { is_expected.to allow_mass_assignment_of(:posted_at) }
  it { is_expected.to allow_mass_assignment_of(:image_legend) }
  it { is_expected.to allow_mass_assignment_of(:body) }
  it { is_expected.to allow_mass_assignment_of(:admin_id) }
  it { is_expected.to allow_mass_assignment_of(:is_published) }

  it { is_expected.to belong_to(:admin) }
end
