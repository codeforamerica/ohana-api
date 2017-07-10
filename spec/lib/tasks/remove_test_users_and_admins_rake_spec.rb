require 'rails_helper'

describe 'remove_test_users_and_admins' do
  include_context 'rake'

  before do
    create(:user)
    create(:admin)
    allow_any_instance_of(IO).to receive(:puts)
    Rails.application.load_seed
  end

  its(:prerequisites) { should include('environment') }

  it 'only removes 2 users' do
    subject.invoke

    expect(User.count).to eq 1
  end

  it 'only removes the demo users' do
    subject.invoke

    expect(User.pluck(:email)).to eq %w[valid@example.com]
  end

  it 'only removes 3 admins' do
    subject.invoke

    expect(Admin.count).to eq 1
  end

  it 'only removes the demo admins' do
    subject.invoke

    expect(Admin.pluck(:email)).to eq %w[moncef@samaritanhouse.com]
  end

  it 'can be run multiple times' do
    subject.invoke
    subject.reenable
    subject.invoke

    expect(User.count).to eq 1
    expect(Admin.count).to eq 1
  end
end
