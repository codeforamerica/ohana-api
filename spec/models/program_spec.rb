require 'rails_helper'

describe Program do
  subject { build(:program) }

  it { is_expected.to be_valid }

  it { is_expected.to allow_mass_assignment_of(:name) }
  it { is_expected.to allow_mass_assignment_of(:alternate_name) }

  it { is_expected.to validate_presence_of(:name).with_message("can't be blank for Program") }
  it do
    is_expected.to validate_presence_of(:organization).with_message("can't be blank for Program")
  end

  it { is_expected.to belong_to(:organization) }
  it { is_expected.to have_many(:services).dependent(:destroy) }

  describe 'auto_strip_attributes' do
    it 'strips extra whitespace before validation' do
      program = build(:program)
      program.valid?
      expect(program.name).to eq('Collection of Services')
      expect(program.alternate_name).to eq('Also Known As')
    end
  end
end
