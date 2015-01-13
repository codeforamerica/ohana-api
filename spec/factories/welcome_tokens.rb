# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :welcome_token do
    code "token"
    is_active true
  end
end
