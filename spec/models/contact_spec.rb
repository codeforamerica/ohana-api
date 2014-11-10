require 'rails_helper'

describe Contact do

  subject { build(:contact) }

  it { is_expected.to be_valid }

  it { is_expected.to allow_mass_assignment_of(:email) }
  it { is_expected.to allow_mass_assignment_of(:department) }
  it { is_expected.to allow_mass_assignment_of(:name) }
  it { is_expected.to allow_mass_assignment_of(:title) }

  it { is_expected.to belong_to(:location).touch(true) }
  it { is_expected.to belong_to(:service).touch(true) }
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to have_many(:phones).dependent(:destroy) }

  it { is_expected.to accept_nested_attributes_for(:phones).allow_destroy(true) }

  it do
    is_expected.to validate_presence_of(:name).
      with_message("can't be blank for Contact")
  end

  it { is_expected.to allow_value('moncef@blah.com').for(:email) }

  it do
    is_expected.not_to allow_value('moncef@blahcom').for(:email).
      with_message('moncef@blahcom is not a valid email')
  end

  describe 'auto_strip_attributes' do
    it 'strips extra whitespace before validation' do
      contact = build(:contact_with_extra_whitespace)
      contact.valid?
      expect(contact.email).to eq('foo@bar.com')
      expect(contact.name).to eq('Foo')
      expect(contact.title).to eq('Bar')
      expect(contact.department).to eq('Screening')
    end
  end
end
