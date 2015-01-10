require 'rails_helper'

describe MailAddress do
  subject { build(:mail_address) }

  it { is_expected.to be_valid }

  it { is_expected.to allow_mass_assignment_of(:attention) }
  it { is_expected.to allow_mass_assignment_of(:street_1) }
  it { is_expected.to allow_mass_assignment_of(:street_2) }
  it { is_expected.to allow_mass_assignment_of(:city) }
  it { is_expected.to allow_mass_assignment_of(:state) }
  it { is_expected.to allow_mass_assignment_of(:postal_code) }
  it { is_expected.to allow_mass_assignment_of(:country_code) }

  it { is_expected.to belong_to(:location).touch(true) }

  it { is_expected.to validate_presence_of(:street_1).with_message("can't be blank for Mail Address") }
  it { is_expected.to validate_presence_of(:city).with_message("can't be blank for Mail Address") }
  it { is_expected.to validate_presence_of(:state).with_message("can't be blank for Mail Address") }
  it { is_expected.to validate_presence_of(:postal_code).with_message("can't be blank for Mail Address") }
  it { is_expected.to validate_presence_of(:country_code).with_message("can't be blank for Mail Address") }

  it do
    is_expected.to ensure_length_of(:state).
      is_at_least(2).
      is_at_most(2).
      with_short_message('is too short (minimum is 2 characters)').
      with_long_message('is too long (maximum is 2 characters)')
  end

  it do
    is_expected.to ensure_length_of(:country_code).
      is_at_least(2).
      is_at_most(2).
      with_short_message('is too short (minimum is 2 characters)').
      with_long_message('is too long (maximum is 2 characters)')
  end

  it { is_expected.to allow_value('90210-1234', '22045').for(:postal_code) }

  it do
    is_expected.not_to allow_value('asdf').
      for(:postal_code).
      with_message('asdf is not a valid ZIP code')
  end

  it { is_expected.not_to allow_value('1234').for(:postal_code) }
  it { is_expected.not_to allow_value('123456').for(:postal_code) }
  it { is_expected.not_to allow_value('12346-689').for(:postal_code) }
  it { is_expected.not_to allow_value('90210-90210').for(:postal_code) }
  it { is_expected.not_to allow_value('90 210').for(:postal_code) }

  describe 'auto_strip_attributes' do
    it 'strips extra whitespace before validation' do
      address = build(:mail_address_with_extra_whitespace)
      address.valid?
      expect(address.attention).to eq('Moncef')
      expect(address.street_1).to eq('8875 La Honda Road')
      expect(address.city).to eq('La Honda')
      expect(address.state).to eq('CA')
      expect(address.postal_code).to eq('94020')
      expect(address.country_code).to eq('US')
    end
  end
end
