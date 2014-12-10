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

  it { is_expected.to validate_uniqueness_of(:name) }

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
    is_expected.not_to allow_value('BBB').
      for(:accreditations).
      with_message('BBB is not an Array.')
  end

  it do
    is_expected.not_to allow_value('BBB').
      for(:funding_sources).
      with_message('BBB is not an Array.')
  end

  it do
    is_expected.not_to allow_value('BBB').
      for(:licenses).
      with_message('BBB is not an Array.')
  end

  it do
    is_expected.not_to allow_value('24/2/2014').
      for(:date_incorporated).
      with_message('24/2/2014 is not a valid date')
  end

  describe 'auto_strip_attributes' do
    it 'strips extra whitespace before validation' do
      org = build(:org_with_extra_whitespace)
      org.valid?
      expect(org.accreditations).to eq(%w(BBB AAA))
      expect(org.alternate_name).to eq('AKA')
      expect(org.description).to eq('Organization created for testing purposes')
      expect(org.email).to eq('foo@bar.org')
      expect(org.funding_sources).to eq(%w(County State))
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
        @org.update_attributes!(urls: ['http://monfresh.com'])
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
end
