require 'rails_helper'

describe Location do

  subject { build(:location) }

  it { is_expected.to be_valid }

  it { is_expected.to allow_mass_assignment_of(:accessibility) }
  it { is_expected.to allow_mass_assignment_of(:admin_emails) }
  it { is_expected.to allow_mass_assignment_of(:alternate_name) }
  it { is_expected.to allow_mass_assignment_of(:description) }
  it { is_expected.to allow_mass_assignment_of(:email) }
  it { is_expected.to allow_mass_assignment_of(:languages) }
  it { is_expected.to allow_mass_assignment_of(:latitude) }
  it { is_expected.to allow_mass_assignment_of(:longitude) }
  it { is_expected.to allow_mass_assignment_of(:name) }
  it { is_expected.to allow_mass_assignment_of(:short_desc) }
  it { is_expected.to allow_mass_assignment_of(:transportation) }
  it { is_expected.to allow_mass_assignment_of(:website) }
  it { is_expected.to allow_mass_assignment_of(:virtual) }

  # Associations
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to have_one(:address).dependent(:destroy) }
  it { is_expected.to have_many(:contacts).dependent(:destroy) }
  it { is_expected.to have_one(:mail_address).dependent(:destroy) }
  it { is_expected.to have_many(:phones).dependent(:destroy) }
  it { is_expected.to have_many(:services).dependent(:destroy) }
  it { is_expected.to have_many(:regular_schedules).dependent(:destroy) }
  it { is_expected.to have_many(:holiday_schedules).dependent(:destroy) }

  it { is_expected.to accept_nested_attributes_for(:address).allow_destroy(true) }
  it { is_expected.to accept_nested_attributes_for(:mail_address).allow_destroy(true) }
  it { is_expected.to accept_nested_attributes_for(:phones).allow_destroy(true) }
  it { is_expected.to accept_nested_attributes_for(:regular_schedules).allow_destroy(true) }
  it { is_expected.to accept_nested_attributes_for(:holiday_schedules).allow_destroy(true) }

  it { is_expected.to validate_presence_of(:name).with_message("can't be blank for Location") }
  it { is_expected.to validate_presence_of(:description).with_message("can't be blank for Location") }
  it { is_expected.to validate_presence_of(:organization).with_message("can't be blank for Location") }

  # Validations
  it { is_expected.to allow_value('http://monfresh.com').for(:website) }

  it do
    is_expected.not_to allow_value('http://').
      for(:website).
      with_message('http:// is not a valid URL')
  end

  it { is_expected.not_to allow_value('http:///codeforamerica.org').for(:website) }
  it { is_expected.not_to allow_value('http://codeforamericaorg').for(:website) }
  it { is_expected.not_to allow_value('www.codeforamerica.org').for(:website) }

  it { is_expected.to allow_value('moncef@blah.com').for(:email) }

  it do
    is_expected.not_to allow_value('moncef@blahcom').
      for(:email).
      with_message('moncef@blahcom is not a valid email')
  end

  it { is_expected.not_to allow_value('moncef.blahcom').for(:email) }
  it { is_expected.not_to allow_value(' foo @bar.com').for(:email) }

  it { is_expected.to allow_value('moncef@blah.com').for(:admin_emails) }

  it do
    is_expected.not_to allow_value('moncef@blahcom').
      for(:admin_emails).
      with_message('moncef@blahcom is not a valid email')
  end

  it { is_expected.not_to allow_value('moncef.blahcom').for(:admin_emails) }
  it { is_expected.not_to allow_value(' foo @bar.com').for(:admin_emails) }

  it do
    is_expected.to enumerize(:accessibility).
      in(
        :cd, :deaf_interpreter, :disabled_parking, :elevator, :ramp, :restroom,
        :tape_braille, :tty, :wheelchair, :wheelchair_van
      )
  end

  it { is_expected.to serialize(:admin_emails).as(Array) }

  describe 'invalidations' do
    context 'non-virtual and without an address' do
      subject { build(:location, address: nil) }
      it { is_expected.not_to be_valid }
    end
  end

  describe 'auto_strip_attributes' do
    it 'strips extra whitespace before validation' do
      loc = build(:loc_with_extra_whitespace)
      loc.valid?
      expect(loc.description).to eq('Provides job training')
      expect(loc.name).to eq('VRS Services')
      expect(loc.short_desc).to eq('Provides job training.')
      expect(loc.transportation).to eq('BART stop 1 block away.')
      expect(loc.website).to eq('http://samaritanhouse.com')
      expect(loc.admin_emails).to eq(['foo@bar.com'])
      expect(loc.email).to eq('bar@foo.com')
      expect(loc.languages).to eq(%w(English Vietnamese))
    end
  end

  # Instance methods
  it { is_expected.to respond_to(:address_street) }
  describe '#address_street' do
    it 'returns address.street_1' do
      expect(subject.address_street).to eq(subject.address.street_1)
    end
  end

  it { is_expected.to respond_to(:mail_address_city) }
  describe '#mail_address_city' do
    it 'returns mail_address.city' do
      loc = build(:mail_address).location
      expect(loc.mail_address_city).to eq(loc.mail_address.city)
    end
  end

  it { is_expected.to respond_to(:full_physical_address) }
  describe '#full_physical_address' do
    it 'joins all address elements into one string' do
      combined = "#{subject.address.street_1}, " \
        "#{subject.address.city}, #{subject.address.state} " \
        "#{subject.address.postal_code}"

      expect(subject.full_physical_address).to eq(combined)
    end
  end

  describe 'slug candidates' do
    before(:each) { @loc = create(:location) }

    context 'when address is present and name is already taken' do
      it 'creates a new slug based on address street' do
        new_loc = create(:nearby_loc)
        new_loc.update_attributes!(name: 'VRS Services')
        expect(new_loc.reload.slug).to eq('vrs-services-250-myrtle-road')
      end
    end

    context 'when mail_address is present and name is taken' do
      it 'creates a new slug based on mail_address city' do
        new_loc = create(:mail_address).location
        new_loc.update_attributes!(name: 'VRS Services')
        expect(new_loc.reload.slug).to eq('vrs-services-belmont')
      end
    end

    context 'when name is not taken' do
      it 'creates a new slug based on name' do
        new_loc = create(:no_address)
        expect(new_loc.reload.slug).to eq('no-address')
      end
    end

    context 'when name is not updated' do
      it "doesn't update slug" do
        @loc.update_attributes!(description: 'new description')
        expect(@loc.reload.slug).to eq('vrs-services')
      end
    end
  end

  describe 'geolocation methods' do
    before(:each) { @loc = create(:location) }

    it "doesn't geocode when address hasn't changed" do
      @loc.update(name: 'new name')
      expect(@loc).not_to receive(:geocode)
      @loc.save!
    end

    it 'geocodes when address has changed' do
      address = {
        street_1: '1 davis drive', city: 'belmont', state: 'CA',
        postal_code: '94002', country_code: 'US'
      }
      coords = [@loc.longitude, @loc.latitude]

      @loc.update!(address_attributes: address)
      expect(@loc.reload.latitude).to_not eq(coords.second)
    end

    it 'resets coordinates when address is removed' do
      @loc.update(
        virtual: true,
        address_attributes: { id: @loc.address.id, _destroy: '1' }
      )
      expect(@loc).not_to receive(:geocode)
      @loc.save!
      expect(@loc.reload.latitude).to be_nil
      expect(@loc.reload.longitude).to be_nil
    end
  end
end
