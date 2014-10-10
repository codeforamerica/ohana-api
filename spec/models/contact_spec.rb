require 'rails_helper'

describe Contact do

  subject { build(:contact) }

  it { is_expected.to be_valid }

  it { is_expected.to allow_mass_assignment_of(:email) }
  it { is_expected.to allow_mass_assignment_of(:extension) }
  it { is_expected.to allow_mass_assignment_of(:fax) }
  it { is_expected.to allow_mass_assignment_of(:name) }
  it { is_expected.to allow_mass_assignment_of(:phone) }
  it { is_expected.to allow_mass_assignment_of(:title) }

  it { is_expected.to belong_to(:location).touch(true) }

  it do
    is_expected.to validate_presence_of(:name).
      with_message("can't be blank for Contact")
  end

  it do
    is_expected.to validate_presence_of(:title).
      with_message("can't be blank for Contact")
  end

  it { is_expected.to allow_value('moncef@blah.com').for(:email) }
  it { is_expected.to allow_value('123.456.7890', '(123) 456-7890').for(:phone) }
  it { is_expected.to allow_value('(123)456-7890').for(:fax) }

  it do
    is_expected.not_to allow_value('moncef@blahcom').
    for(:email).
    with_message('moncef@blahcom is not a valid email')
  end

  it do
    is_expected.not_to allow_value('123456789').
    for(:phone).
    with_message('123456789 is not a valid US phone or fax number')
  end

  it do
    is_expected.not_to allow_value('asdf').
    for(:fax).
    with_message('asdf is not a valid US phone or fax number')
  end

  describe 'auto_strip_attributes' do
    it 'strips extra whitespace before validation' do
      contact = build(:contact_with_extra_whitespace)
      contact.valid?
      expect(contact.email).to eq('foo@bar.com')
      expect(contact.extension).to eq('x1234')
      expect(contact.fax).to eq('123-456-7890')
      expect(contact.name).to eq('Foo')
      expect(contact.phone).to eq('123-456-7890')
      expect(contact.title).to eq('Bar')
    end
  end
end
