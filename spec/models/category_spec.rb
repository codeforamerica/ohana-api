require 'rails_helper'

describe Category do
  subject { build(:category) }

  it { is_expected.to be_valid }

  it { is_expected.to allow_mass_assignment_of(:name) }
  it { is_expected.to allow_mass_assignment_of(:oe_id) }

  it { is_expected.to have_and_belong_to_many(:services) }

  it do
    is_expected.to validate_presence_of(:name).
      with_message("can't be blank for Category")
  end

  it do
    is_expected.to validate_presence_of(:oe_id).
      with_message("can't be blank for Category")
  end

  it { is_expected.to respond_to(:slug_candidates) }

  describe 'slug candidates' do
    before(:each) { @category = create(:category) }

    context 'when name is already taken' do
      before(:each) do
        @new_category = create(:health)
        @new_category.update_attributes!(name: 'Food')
      end

      it 'creates a new slug based on oe_id' do
        expect(@new_category.reload.slug).to eq('food-102')
      end

      it 'is accessible by its old slug' do
        category = Category.find('health')
        expect(category.id).to eq(@new_category.id)
      end
    end

    context 'when name is not taken' do
      it 'creates a new slug based on name' do
        new_category = create(:health)
        expect(new_category.reload.slug).to eq('health')
      end
    end

    context 'when name is not updated' do
      it "doesn't update slug" do
        @category.update_attributes!(oe_id: '103')
        expect(@category.reload.slug).to eq('food')
      end
    end
  end
end
