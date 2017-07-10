require 'rails_helper'

describe Organization do
  subject { build(:organization) }

  it { is_expected.to be_valid }

  it { is_expected.to allow_mass_assignment_of(:accreditations) }
  it { is_expected.to allow_mass_assignment_of(:alternate_name) }
  it { is_expected.to allow_mass_assignment_of(:date_incorporated) }
  it { is_expected.to allow_mass_assignment_of(:description) }
  it { is_expected.to allow_mass_assignment_of(:email) }
  it { is_expected.to allow_mass_assignment_of(:funding_sources) }
  it { is_expected.to allow_mass_assignment_of(:legal_status) }
  it { is_expected.to allow_mass_assignment_of(:licenses) }
  it { is_expected.to allow_mass_assignment_of(:name) }
  it { is_expected.to allow_mass_assignment_of(:tax_id) }
  it { is_expected.to allow_mass_assignment_of(:tax_status) }
  it { is_expected.to allow_mass_assignment_of(:website) }

  it { is_expected.to have_many(:locations).dependent(:destroy) }
  it { is_expected.to have_many(:programs).dependent(:destroy) }
  it { is_expected.to have_many(:contacts).dependent(:destroy) }

  it { is_expected.to have_many(:phones).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for(:phones).allow_destroy(true) }

  it do
    is_expected.to validate_presence_of(:name).
      with_message("can't be blank for Organization")
  end

  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

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

  describe 'conversion of string date to Date object' do
    context 'when app expects day/month format' do
      it 'raises an error when the format is month/day' do
        allow_any_instance_of(DateValidator).to receive(:month_day?).and_return(false)
        allow_any_instance_of(DateValidator).to receive(:day_month?).and_return(true)

        org = build(:organization, date_incorporated: '2/24/2014')
        org.save

        expect(org.errors[:date_incorporated].first).to eq('2/24/2014 is not a valid date')
      end
    end

    context 'when app expects month/day format' do
      it 'raises an error when the format is day/month' do
        org = build(:organization, date_incorporated: '24/2/2014')
        org.save

        expect(org.errors[:date_incorporated].first).to eq('24/2/2014 is not a valid date')
      end
    end

    context 'when app expects month/day format' do
      it 'accepts the month/day format' do
        org = build(:organization, date_incorporated: '2/24/2014')

        expect(org.valid?).to eq true
      end
    end

    context 'when the format is Month day, year' do
      it 'accepts the format' do
        org = build(:organization, date_incorporated: 'January 12, 2014')

        expect(org.valid?).to eq true
      end
    end
  end

  describe 'array validations' do
    it 'raises an error when the attribute is not an array' do
      org = build(:organization, accreditations: 'AAA', funding_sources: 'BBB', licenses: 'CCC')
      org.save

      expect(org.errors[:accreditations].first).to eq('AAA is not an Array.')
      expect(org.errors[:funding_sources].first).to eq('BBB is not an Array.')
      expect(org.errors[:licenses].first).to eq('CCC is not an Array.')
    end
  end

  describe 'auto_strip_attributes' do
    it 'strips extra whitespace before validation' do
      org = build(:org_with_extra_whitespace)
      org.valid?
      expect(org.accreditations).to eq(%w[BBB AAA])
      expect(org.alternate_name).to eq('AKA')
      expect(org.description).to eq('Organization created for testing purposes')
      expect(org.email).to eq('foo@bar.org')
      expect(org.funding_sources).to eq(%w[County State])
      expect(org.legal_status).to eq('nonprofit')
      expect(org.licenses).to eq(['Health Bureau'])
      expect(org.name).to eq('Food Pantry')
      expect(org.tax_id).to eq('12345')
      expect(org.tax_status).to eq('501c3')
      expect(org.website).to eq('http://cfa.org')
    end
  end

  describe 'slug' do
    before(:each) { @org = create(:organization) }

    context 'when name is not updated' do
      it "doesn't update slug" do
        @org.update_attributes!(website: 'http://monfresh.com')
        expect(@org.reload.slug).to eq('parent-agency')
      end
    end

    context 'when name is updated' do
      it 'updates slug based on name' do
        @org.update_attributes!(name: 'New Org Name')
        expect(@org.reload.slug).to eq('new-org-name')
      end
    end
  end

  describe 'touching locations' do
    context 'when does not have locations' do
      it 'does not touch locations' do
        org = build(:organization)

        expect(org).to_not receive(:touch_locations)

        org.save
      end
    end

    context 'when name has not changed' do
      it 'does not touch locations' do
        org = create(:location).organization

        expect(org).to_not receive(:touch_locations)

        org.update(description: 'foo')
      end
    end

    context 'when name has changed and org has locations' do
      it 'touches locations' do
        org = create(:location).organization

        expect(org).to receive(:touch_locations)

        org.update(name: 'foo')
      end
    end
  end
end
