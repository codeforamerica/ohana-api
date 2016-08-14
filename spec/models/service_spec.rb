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
  it { is_expected.to allow_mass_assignment_of(:application_process) }
  it { is_expected.to allow_mass_assignment_of(:interpretation_services) }
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

  it { is_expected.to have_many(:regular_schedules).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for(:regular_schedules).allow_destroy(true) }
  it { is_expected.to have_many(:holiday_schedules).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for(:holiday_schedules).allow_destroy(true) }
  it { is_expected.to have_many(:contacts).dependent(:destroy) }
  it { is_expected.to have_many(:phones).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for(:phones).allow_destroy(true) }

  it { is_expected.to validate_presence_of(:name).with_message("can't be blank for Service") }
  it do
    is_expected.to validate_presence_of(:description).
      with_message("can't be blank for Service")
  end
  it do
    is_expected.to_not validate_presence_of(:application_process).
      with_message("can't be blank for Service")
  end
  it { is_expected.to validate_presence_of(:location).with_message("can't be blank for Service") }
  it { is_expected.to validate_presence_of(:status).with_message("can't be blank for Service") }

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

  it { is_expected.to enumerize(:status).in(:active, :defunct, :inactive) }

  describe 'array validations' do
    it 'raises an error when the attribute is not an array' do
      service = build(
        :service, accepted_payments: 'AAA', required_documents: 'BBB', languages: 'CCC'
      )
      service.save

      expect(service.errors[:accepted_payments].first).to eq('AAA is not an Array.')
      expect(service.errors[:required_documents].first).to eq('BBB is not an Array.')
      expect(service.errors[:languages].first).to eq('CCC is not an Array.')
    end
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
      expect(service.application_process).to eq('in person')
      expect(service.interpretation_services).to eq('CTS LanguageLink')
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

  describe 'association callbacks' do
    before do
      create_service
      @old_timestamp = @location.updated_at
      @food = create(:category)
      @health = create(:health)
      @service.category_ids = [@food.id]
      @service.save!
    end

    it 'calls .touch_location when category is added' do
      expect(@service).to receive(:touch_location).once.with(@health)
      @service.category_ids = [@food.id, @health.id]
    end

    it 'calls .touch_location when category is removed' do
      expect(@service).to receive(:touch_location).once.with(@food)
      @service.category_ids = []
    end

    it 'calls .touch_location twice when category is replaced' do
      expect(@service).to receive(:touch_location).twice
      @service.category_ids = [@health.id]
    end

    it 'touches location when category is added' do
      expect(@location.updated_at).to_not eq @old_timestamp
    end
  end
end
