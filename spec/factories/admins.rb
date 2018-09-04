# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryBot.define do
  factory :admin do
    name { 'Org Admin' }
    email { 'moncef@samaritanhouse.com' }
    password { 'ohanatest' }
    password_confirmation { 'ohanatest' }
    confirmed_at { Time.zone.now }

    factory :super_admin do
      name { 'Super Admin' }
      super_admin { true }
    end
  end

  factory :unconfirmed_admin, class: :admin do
    name { 'Unconfirmed admin' }
    email { 'invalid@example.com' }
    password { 'ohanatest' }
    password_confirmation { 'ohanatest' }
  end

  factory :admin_with_generic_email, class: :admin do
    name { 'Generic User' }
    email { 'moncef@gmail.com' }
    password { 'ohanatest' }
    password_confirmation { 'ohanatest' }
    confirmed_at { Time.zone.now }
  end

  factory :location_admin, class: :admin do
    name { 'Moncef Belyamani' }
    email { 'moncef@smcgov.org' }
    password { 'ohanatest' }
    password_confirmation { 'ohanatest' }
    confirmed_at { Time.zone.now }
  end
end
