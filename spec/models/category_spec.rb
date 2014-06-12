require 'spec_helper'

describe Category do
  subject { build(:category) }

  it { should be_valid }

  it { should have_and_belong_to_many(:services) }

  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:oe_id) }

  it do
    should validate_presence_of(:name).
      with_message("can't be blank for Category")
  end

  it do
    should validate_presence_of(:oe_id).
      with_message("can't be blank for Category")
  end

  it { should respond_to(:slug_candidates) }

  describe 'slug candidates' do
    before(:each) { @category = create(:category) }

    context 'when name is already taken' do
      it 'creates a new slug based on oe_id' do
        new_category = create(:health)
        new_category.update_attributes!(name: 'Food')
        expect(new_category.reload.slug).to eq('food-102')
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
