# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    name "Burlingame, Easton Branch"
    street "1800 Easton Drive"
    zipcode "94010"
    city "Burlingame"
    state "CA"
    coordinates [-122.371448, 37.583849]
    keywords ["library"]
    phones [[{ number: "650 851-1210",
               department: "Information",
               phone_hours: "(Monday-Friday, 9-12, 1-5)" }]]
    association :organization
  end

  factory :nearby_loc, class: Location do
    name "Redwood City Main"
    street "1000 Broadway"
    zipcode "94010"
    city "Burlingame"
    state "CA"
    coordinates [-122.362882, 37.588935]
    keywords ["library"]
    association :organization
  end

  factory :farmers_market_loc, class: Location do
    name "Pescadero Grown"
    street "8875 La Honda Road"
    zipcode "94020"
    city "La Honda"
    state "CA"
    coordinates [-122.274369, 37.317983]
    keywords ["market"]
    urls ["http://Www.pescaderogrown.org"]
    payments_accepted ["Credit", "WIC", "SFMNP", "SNAP"]
    products_sold ["Cheese", "Flowers", "Eggs", "Seafood", "Herbs"]
    association :organization, factory: :organization
  end

  factory :food_stamps_in_parent_name, class: Location do
    name "Samaritan House Child"
    street "1800 Easton Drive"
    zipcode "94010"
    city "Burlingame"
    state "CA"
    association :organization, factory: :food_stamps_agency
  end

  factory :food_stamps_in_keywords, class: Location do
    name "Query In Keywords"
    street "1800 Easton Drive"
    zipcode "94010"
    city "Burlingame"
    state "CA"
    keywords ["food stamps"]
    association :organization, factory: :generic_agency
    after(:create) { |loc| loc.organization.save }
  end

  factory :food_stamps_name, class: Location do
    name "Food Stamps in name"
    keywords ["child care"]
    street "1800 Easton Drive"
    zipcode "94010"
    city "Burlingame"
    state "CA"
    association :organization, factory: :organization
    after(:create) { |loc| loc.organization.save }
  end

  factory :food_stamps_child, class: Location do
    name "Boo"
    keywords ["child care"]
    street "1800 Easton Drive"
    zipcode "94010"
    city "Burlingame"
    state "CA"
    association :organization, factory: :food_stamps_parent
  end
end