# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :api_application do
    name 'test app'
    main_url 'http://cfa.org'
    callback_url 'http://cfa.org/callback'

    factory :app_with_extra_whitespace do
      name '  app   with extra  whitespace '
    end
  end
end
