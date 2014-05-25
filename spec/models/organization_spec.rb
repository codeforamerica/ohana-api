require 'spec_helper'

describe Organization do

  subject { build(:organization) }

  it { should be_valid }

  it do
    should validate_presence_of(:name).
      with_message("can't be blank for Organization")
  end

  describe 'slug candidates' do
    before(:each) { @org = create(:organization) }

    context 'when name is already taken' do
      it 'creates a new slug' do
        new_org = Organization.create!(name: 'Parent Agency')
        new_org.reload.slug.should_not eq('parent-agency')
      end
    end

    context 'when url is present and name is taken' do
      it 'creates a new slug based on url' do
        new_org = Organization.create!(
          name: 'Parent Agency',
          urls: ['http://monfresh.com']
        )
        new_org.reload.slug.should eq('parent-agency-monfresh-com')
      end
    end

    context 'when name is not updated' do
      it "doesn't update slug" do
        @org.update_attributes!(urls: ['http://monfresh.com'])
        @org.reload.slug.should eq('parent-agency')
      end
    end
  end
end
