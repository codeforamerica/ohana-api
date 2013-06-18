# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'Test User'
    email 'example@example.com'
    password 'mong01dtest'
    password_confirmation 'mong01dtest'
    # required if the Devise Confirmable module is used
    confirmed_at Time.now
  end
end
