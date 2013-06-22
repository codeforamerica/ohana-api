# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'Test User'
    email 'valid@example.com'
    password 'mong01dtest'
    password_confirmation 'mong01dtest'
    # required if the Devise Confirmable module is used
    confirmed_at Time.now
  end

  factory :user_with_app, :class => :user do
    name 'User with app'
    email 'app@example.com'
    password 'mong01dtest'
    password_confirmation 'mong01dtest'
    confirmed_at Time.now
    api_applications [{ name: "first app",
                        main_url: "http://ohanapi",
                        callback_url: "http://callme" }]

  end

  factory :unconfirmed_user, :class => :user do
    name 'Unconfirmed User'
    email 'invalid@example.com'
    password 'mong01dtest'
    password_confirmation 'mong01dtest'
  end
end
