# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :api_application do
    name 'test app'
    main_url 'http://cfa.org'
    callback_url 'http://cfa.org/callback'
  end
end
