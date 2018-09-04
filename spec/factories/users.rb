# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :user do
    name { 'Test User' }
    email { 'valid@example.com' }
    password { 'mong01dtest' }
    password_confirmation { 'mong01dtest' }
    # required if the Devise Confirmable module is used
    confirmed_at { Time.zone.now }

    factory :user_with_app do
      after(:create) do |user|
        create(:api_application, user: user)
      end
    end
  end

  factory :unconfirmed_user, class: :user do
    name { 'Unconfirmed User' }
    email { 'invalid@example.com' }
    password { 'mong01dtest' }
    password_confirmation { 'mong01dtest' }
  end
end
