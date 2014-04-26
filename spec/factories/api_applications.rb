# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :api_application do
    name 'test app'
    main_url 'http://localhost'
    callback_url 'http://localhost/callback'
  end
end
