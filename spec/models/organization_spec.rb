require 'rails_helper'

describe Organization do

  subject { build(:organization) }

  it { is_expected.to be_valid }

  it { is_expected.to allow_mass_assignment_of(:name) }
  it { is_expected.to allow_mass_assignment_of(:urls) }

  it { is_expected.to have_many :locations }

  it do
    is_expected.to validate_presence_of(:name).
      with_message("can't be blank for Organization")
  end

  it { is_expected.to validate_uniqueness_of(:name) }

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

  describe 'auto_strip_attributes' do
    it 'strips extra whitespace before validation' do
      org = build(:org_with_extra_whitespace)
      org.valid?
      expect(org.name).to eq('Food Pantry')
      expect(org.urls).to eq(['http://cfa.org'])
    end
  end

  it { is_expected.to respond_to(:domain_name) }
  describe '#domain_name' do
    it "returns the domain part of the organization's first URL" do
      subject = build(:org_with_urls)
      expect(subject.domain_name).to eq('monfresh.com')
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
