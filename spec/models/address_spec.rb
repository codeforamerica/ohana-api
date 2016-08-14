require 'rails_helper'

describe Address do
  subject { build(:address) }

  it { is_expected.to be_valid }

  it { is_expected.to allow_mass_assignment_of(:address_1) }
  it { is_expected.to allow_mass_assignment_of(:address_2) }
  it { is_expected.to allow_mass_assignment_of(:city) }
  it { is_expected.to allow_mass_assignment_of(:state_province) }
  it { is_expected.to allow_mass_assignment_of(:postal_code) }
  it { is_expected.to allow_mass_assignment_of(:country) }

  it { is_expected.to belong_to(:location).touch(true) }

  it { is_expected.to validate_presence_of(:address_1).with_message("can't be blank for Address") }
  it { is_expected.to validate_presence_of(:city).with_message("can't be blank for Address") }
  it do
    is_expected.to validate_presence_of(:state_province).
      with_message(t('errors.messages.invalid_state_province'))
  end
  it do
    is_expected.to validate_presence_of(:postal_code).with_message("can't be blank for Address")
  end
  it { is_expected.to validate_presence_of(:country).with_message("can't be blank for Address") }

  it do
    is_expected.to validate_length_of(:country).
      is_at_least(2).
      is_at_most(2).
      with_short_message('is too short (minimum is 2 characters)').
      with_long_message('is too long (maximum is 2 characters)')
  end

  it { is_expected.to allow_value('90210-1234', '22045').for(:postal_code) }

  it do
    is_expected.not_to allow_value('asdf').for(:postal_code).
      with_message('asdf is not a valid ZIP code')
  end

  it { is_expected.not_to allow_value('1234').for(:postal_code) }
  it { is_expected.not_to allow_value('123456').for(:postal_code) }
  it { is_expected.not_to allow_value('12346-689').for(:postal_code) }
  it { is_expected.not_to allow_value('90210-90210').for(:postal_code) }
  it { is_expected.not_to allow_value('90 210').for(:postal_code) }

  describe 'auto_strip_attributes' do
    it 'strips extra whitespace before validation' do
      address = build(:address_with_extra_whitespace)
      address.valid?
      expect(address.address_1).to eq('8875 La Honda Road')
      expect(address.city).to eq('La Honda')
      expect(address.state_province).to eq('CA')
      expect(address.postal_code).to eq('94020')
      expect(address.country).to eq('US')
    end
  end

  describe 'callbacks' do
    before(:each) { @loc = create(:location) }

    it 'calls reset_location_coordinates after destroy' do
      expect(@loc.address).to receive(:reset_location_coordinates)
      @loc.address.destroy
    end
  end

  describe 'state_province validations' do
    context 'when country is US' do
      it 'validates length is 2 characters' do
        address = build(:address, country: 'US', state_province: 'California')
        address.save

        expect(address.errors[:state_province].first).
          to eq t('errors.messages.invalid_state_province')
      end
    end

    context 'when country is CA' do
      it 'validates length is 2 characters' do
        address = build(:address, country: 'CA', state_province: 'Ontario')
        address.save

        expect(address.errors[:state_province].first).
          to eq t('errors.messages.invalid_state_province')
      end
    end

    context 'when country is not CA or US' do
      it 'does not validate length' do
        address = build(:address, country: 'UK', state_province: 'Kent')
        address.save

        expect(address.errors[:state_province]).to be_empty
      end
    end

    context 'when country is not CA or US' do
      it 'does not validate presence' do
        address = build(:address, country: 'ES', state_province: '')
        address.save

        expect(address.errors[:state_province]).to be_empty
      end
    end
  end
end
