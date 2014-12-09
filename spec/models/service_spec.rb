require 'rails_helper'

describe Service do
  subject { build(:service) }

  it { is_expected.to be_valid }

  it { is_expected.to allow_mass_assignment_of(:accepted_payments) }
  it { is_expected.to allow_mass_assignment_of(:alternate_name) }
  it { is_expected.to allow_mass_assignment_of(:audience) }
  it { is_expected.to allow_mass_assignment_of(:description) }
  it { is_expected.to allow_mass_assignment_of(:eligibility) }
  it { is_expected.to allow_mass_assignment_of(:email) }
  it { is_expected.to allow_mass_assignment_of(:fees) }
  it { is_expected.to allow_mass_assignment_of(:funding_sources) }
  it { is_expected.to allow_mass_assignment_of(:how_to_apply) }
  it { is_expected.to allow_mass_assignment_of(:keywords) }
  it { is_expected.to allow_mass_assignment_of(:languages) }
  it { is_expected.to allow_mass_assignment_of(:name) }
  it { is_expected.to allow_mass_assignment_of(:required_documents) }
  it { is_expected.to allow_mass_assignment_of(:service_areas) }
  it { is_expected.to allow_mass_assignment_of(:status) }
  it { is_expected.to allow_mass_assignment_of(:website) }
  it { is_expected.to allow_mass_assignment_of(:wait_time) }

  it { is_expected.to belong_to(:location).touch(true) }
  it { is_expected.to belong_to(:program) }

  # This is no longer working in Rails 4.1.2. I opened an issue:
  # https://github.com/thoughtbot/shoulda-matchers/issues/549
  xit { is_expected.to have_and_belong_to_many(:categories).order('taxonomy_id asc') }

  it { is_expected.to have_many(:regular_schedules).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for(:regular_schedules).allow_destroy(true) }
  it { is_expected.to have_many(:holiday_schedules).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for(:holiday_schedules).allow_destroy(true) }
  it { is_expected.to have_many(:contacts).dependent(:destroy) }
  it { is_expected.to have_many(:phones).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for(:phones).allow_destroy(true) }

  it { is_expected.to validate_presence_of(:name).with_message("can't be blank for Service") }
  it { is_expected.to validate_presence_of(:description).with_message("can't be blank for Service") }
  it { is_expected.to validate_presence_of(:how_to_apply).with_message("can't be blank for Service") }
  it { is_expected.to validate_presence_of(:location).with_message("can't be blank for Service") }

  it { is_expected.to serialize(:funding_sources).as(Array) }
  it { is_expected.to serialize(:keywords).as(Array) }
  it { is_expected.to serialize(:service_areas).as(Array) }

  it { is_expected.not_to allow_value('codeforamerica.org').for(:email) }
  it { is_expected.not_to allow_value('codeforamerica@org').for(:email) }
  it { is_expected.to allow_value('code@foramerica.org').for(:email) }

  it { is_expected.to allow_value('http://monfresh.com').for(:website) }
  it { is_expected.not_to allow_value('http:///codeforamerica.org').for(:website) }
  it { is_expected.not_to allow_value('http://codeforamericaorg').for(:website) }
  it { is_expected.not_to allow_value('www.codeforamerica.org').for(:website) }
  it do
    is_expected.not_to allow_value('http://').
      for(:website).
      with_message('http:// is not a valid URL')
  end

  it do
    is_expected.not_to allow_value(%w(belmont)).
      for(:service_areas).
      with_message('belmont is not a valid service area')
  end

  it { is_expected.to allow_value(%w(Belmont Atherton)).for(:service_areas) }

  it { is_expected.to allow_value('active', 'defunct', 'inactive').for(:status) }
  it { is_expected.not_to allow_value('Active').for(:status) }

  it do
    is_expected.not_to allow_value('BBB').
      for(:accepted_payments).
      with_message('BBB is not an Array.')
  end

  it do
    is_expected.not_to allow_value('BBB').
      for(:required_documents).
      with_message('BBB is not an Array.')
  end

  it do
    is_expected.not_to allow_value('BBB').
      for(:languages).
      with_message('BBB is not an Array.')
  end

  describe 'auto_strip_attributes' do
    it 'strips extra whitespace before validation' do
      service = build(:service_with_extra_whitespace)
      service.valid?
      expect(service.accepted_payments).to eq(%w(Cash Credit))
      expect(service.alternate_name).to eq('AKA')
      expect(service.audience).to eq('Low-income seniors')
      expect(service.description).to eq('SNAP market')
      expect(service.eligibility).to eq('seniors')
      expect(service.email).to eq('foo@example.com')
      expect(service.fees).to eq('none')
      expect(service.funding_sources).to eq(['County'])
      expect(service.how_to_apply).to eq('in person')
      expect(service.keywords).to eq(%w(health yoga))
      expect(service.languages).to eq(%w(French English))
      expect(service.name).to eq('Benefits')
      expect(service.required_documents).to eq(['ID'])
      expect(service.service_areas).to eq(['Belmont'])
      expect(service.status).to eq('active')
      expect(service.website).to eq('http://www.monfresh.com')
      expect(service.wait_time).to eq('2 days')
    end
  end
end
