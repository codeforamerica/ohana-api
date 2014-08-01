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

  describe 'slug candidates' do
    before(:each) { @org = create(:organization) }

    context 'when name is already taken' do
      it 'creates a new slug' do
        new_org = Organization.create!(name: 'Parent Agency')
        expect(new_org.reload.slug).not_to eq('parent-agency')
      end
    end

    context 'when url is present and name is taken' do
      it 'creates a new slug based on url' do
        new_org = Organization.create!(
          name: 'Parent Agency',
          urls: ['http://monfresh.com']
        )
        expect(new_org.reload.slug).to eq('parent-agency-monfresh-com')
      end
    end

    context 'when name is not updated' do
      it "doesn't update slug" do
        @org.update_attributes!(urls: ['http://monfresh.com'])
        expect(@org.reload.slug).to eq('parent-agency')
      end
    end
  end

  describe 'track changes' do
    subject { create(:organization) }

    it 'starts with no last_changes' do
      expect(subject.last_changed).to be_blank
      expect(subject.last_changes).to be_blank
    end

    it 'adds last changes on update' do
      old_name = subject.name
      admin = create(:admin)
      subject.name = 'new name'
      subject.current_admin = admin
      subject.save
      expect(subject.last_changed).to be_equal(admin)
      expect(subject.last_changes['name']).to be_eql([old_name, 'new name'])
    end

    it 'does not update last_changes if there are no changes' do
      subject.update(name: 'new name')
      expect(subject.last_changes).to_not be_blank
      last_changes = subject.last_changes
      subject.save
      expect(subject.last_changes).to be_eql(last_changes)
    end
  end
end
