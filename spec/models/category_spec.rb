require 'rails_helper'

describe Category do
  subject { build(:category) }

  it { is_expected.to be_valid }

  it { is_expected.to allow_mass_assignment_of(:name) }
  it { is_expected.to allow_mass_assignment_of(:taxonomy_id) }

  it { is_expected.to have_and_belong_to_many(:services) }

  it do
    is_expected.to validate_presence_of(:name).
      with_message("can't be blank for Category")
  end

  it do
    is_expected.to validate_presence_of(:taxonomy_id).
      with_message("can't be blank for Category")
  end

  it do
    is_expected.to validate_uniqueness_of(:taxonomy_id).
      with_message('id has already been taken')
  end
end
