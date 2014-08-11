require 'rails_helper'

describe Service do
  subject { build(:service) }

  it { is_expected.to be_valid }

  it { is_expected.to allow_mass_assignment_of(:audience) }
  it { is_expected.to allow_mass_assignment_of(:description) }
  it { is_expected.to allow_mass_assignment_of(:eligibility) }
  it { is_expected.to allow_mass_assignment_of(:fees) }
  it { is_expected.to allow_mass_assignment_of(:funding_sources) }
  it { is_expected.to allow_mass_assignment_of(:keywords) }
  it { is_expected.to allow_mass_assignment_of(:how_to_apply) }
  it { is_expected.to allow_mass_assignment_of(:name) }
  it { is_expected.to allow_mass_assignment_of(:service_areas) }
  it { is_expected.to allow_mass_assignment_of(:short_desc) }
  it { is_expected.to allow_mass_assignment_of(:urls) }
  it { is_expected.to allow_mass_assignment_of(:wait) }

  it { is_expected.to belong_to(:location).touch(true) }

  # This is no longer working in Rails 4.1.2. I opened an issue:
  # https://github.com/thoughtbot/shoulda-matchers/issues/549
  xit { is_expected.to have_and_belong_to_many(:categories).order('oe_id asc') }

  it { is_expected.to serialize(:funding_sources).as(Array) }
  it { is_expected.to serialize(:keywords).as(Array) }
  it { is_expected.to serialize(:urls).as(Array) }

  it { is_expected.to allow_value('http://monfresh.com').for(:urls) }

  it do
    is_expected.not_to allow_value('http://').
    for(:urls).
    with_message('http:// is not a valid URL')
  end

  it { is_expected.not_to allow_value('http:///codeforamerica.org').for(:urls) }
  it { is_expected.not_to allow_value('http://codeforamericaorg').for(:urls) }
  it { is_expected.not_to allow_value('www.codeforamerica.org').for(:urls) }
  it { is_expected.not_to allow_value('').for(:urls) }

  it do
    is_expected.not_to allow_value(%w(belmont)).
    for(:service_areas).
    with_message(
      'At least one service area is improperly formatted, ' \
      'or is not an accepted city or county name. Please make sure all ' \
      'words are capitalized.'
    )
  end

  it { is_expected.to allow_value(%w(Belmont Atherton)).for(:service_areas) }

  describe 'auto_strip_attributes' do
    it 'strips extra whitespace before validation' do
      service = build(:service_with_extra_whitespace)
      service.valid?
      expect(service.audience).to eq('Low-income seniors')
      expect(service.description).to eq('SNAP market')
      expect(service.eligibility).to eq('seniors')
      expect(service.fees).to eq('none')
      expect(service.funding_sources).to eq(['County'])
      expect(service.how_to_apply).to eq('in person')
      expect(service.keywords).to eq(%w(health yoga))
      expect(service.name).to eq('Benefits')
      expect(service.short_desc).to eq('processes applications')
      expect(service.service_areas).to eq(['Belmont'])
      expect(service.urls).to eq(['http://www.monfresh.com'])
      expect(service.wait).to eq('2 days')
    end
  end
end
