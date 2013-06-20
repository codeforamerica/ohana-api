# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'Test User'
    email 'valid@example.com'
    password 'mong01dtest'
    password_confirmation 'mong01dtest'
    # required if the Devise Confirmable module is used
    confirmed_at Time.now
    #api_applications { [FactoryGirl.build(:api_application1)] }
  end

  factory :unconfirmed_user, :class => :user do
    name 'Unconfirmed User'
    email 'invalid@example.com'
    password 'mong01dtest'
    password_confirmation 'mong01dtest'
  end

  factory :api_application1, :class => :api_application do
    name "first app"
    main_url "http://ohanapi.org"
    callback_url "http://callme"
  end
end
