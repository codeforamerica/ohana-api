require 'spec_helper'

describe Organization do

  subject { build(:organization) }

  it { should be_valid }

  describe "invalidations" do
    context "without a name" do
      subject { build(:organization, name: nil)}
      it { should_not be_valid }
    end
  end
end
