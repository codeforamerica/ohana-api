require 'spec_helper'

describe Location do

  subject { build(:location) }

  it { should be_valid }

  # Associations
  it { should belong_to :organization }
  it { should have_one :address }
  it { should have_many :contacts }
  it { should have_many :faxes }
  it { should have_one :mail_address }
  it { should have_many :phones }
  it { should have_many :services }

  # Instance methods
  it { should respond_to(:full_physical_address) }

  describe '#full_physical_address' do
    it 'joins all address elements into one string' do
      combined = "#{subject.address.street}, " \
        "#{subject.address.city}, #{subject.address.state} " \
        "#{subject.address.zip}"

      expect(subject.full_physical_address).to eq(combined)
    end
  end

  # Attribute normalization
  it do
    should normalize_attribute(:urls).from(' http://www.codeforamerica.org  ').
      to('http://www.codeforamerica.org')
  end

  describe 'invalidations' do
    context 'without a name' do
      subject { build(:location, name: nil) }
      it { should_not be_valid }
    end

    context 'with an empty name' do
      subject { build(:location, name: '') }
      it { should_not be_valid }
    end

    context 'without a description' do
      subject { build(:location, description: nil) }
      it { should_not be_valid }
    end

    context 'with URL containing 3 slashes' do
      subject { build(:location, urls: ['http:///codeforamerica.org']) }
      it { should_not be_valid }
    end

    context 'with URL missing a period' do
      subject { build(:location, urls: ['http://codeforamericaorg']) }
      it { should_not be_valid }
    end

    context 'URL without protocol' do
      subject { build(:location, urls: ['www.codeforamerica.org']) }
      it { should_not be_valid }
    end

    context 'URL with trailing whitespace' do
      subject { build(:location, urls: ['http://www.codeforamerica.org ']) }
      it { should_not be_valid }
    end

    context 'without an address' do
      subject { build(:location, address: nil) }
      it { should_not be_valid }
    end

    context 'email without period' do
      subject { build(:location, emails: ['moncef@blahcom']) }
      it { should_not be_valid }
    end

    context 'email without @' do
      subject { build(:location, emails: ['moncef.blahcom']) }
      it { should_not be_valid }
    end

    context 'admin email without @' do
      subject { build(:location, admin_emails: ['moncef.blahcom']) }
      it { should_not be_valid }
    end
  end

  describe 'valid data' do
    context 'URL with wwww' do
      subject { build(:location, urls: ['http://wwww.codeforamerica.org']) }
      it { should be_valid }
    end

    context 'non-US URL' do
      subject { build(:location, urls: ['http://www.monfresh.com.au']) }
      it { should be_valid }
    end

    context 'URL with capitalizations' do
      subject { build(:location, urls: ['HTTP://WWW.monfresh.com.au']) }
      it { should be_valid }
    end

    context 'email with trailing whitespace' do
      subject { build(:location, emails: ['moncef@blah.com ']) }
      it { should be_valid }
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
        new_loc = create(:no_address)
        new_loc.update_attributes!(name: 'VRS Services')
        expect(new_loc.reload.slug).to eq('vrs-services-la-honda')
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
end
