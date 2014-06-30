# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin do
    name 'Test Admin'
    email 'admin@example.com'
    password 'ohanatest'
    password_confirmation 'ohanatest'
    confirmed_at Time.now
  end
end
