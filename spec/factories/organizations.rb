# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name "Burlingame, Easton Branch"
    street_address "1800 Easton Drive"
    zipcode "94010"
    city "Burlingame"
    state "CA"
    phones [[{ number: "650 851-1210",
               department: "Information",
               phone_hours: "(Monday-Friday, 9-12, 1-5)" }]]
    coordinates [-122.371448, 37.583849]
    keywords ["library"]
    languages_spoken ["spanish", "vietnamese", "english"]
    after(:create) { |org| org.index.refresh }
  end

  factory :nearby_org, class: Organization do
    name "Redwood City Main"
    street_address "1000 Broadway"
    zipcode "94010"
    city "Burlingame"
    state "CA"
    coordinates [-122.362882, 37.588935]
    keywords ["library"]
    languages_spoken ["french", "russian"]
    after(:create) { |org| org.index.refresh }
  end

  factory :farmers_market, class: Organization do
    name "Pescadero Grown"
    street_address "8875 La Honda Road"
    zipcode "94020"
    city "La Honda"
    state "CA"
    coordinates [-122.274369, 37.317983]
    keywords ["market"]
    urls ["http://Www.pescaderogrown.org"]
    payments_accepted ["Credit", "WIC", "SFMNP", "SNAP"]
    products_sold ["Cheese", "Flowers", "Eggs", "Seafood", "Herbs"]
    after(:create) { |org| org.index.refresh }
  end

  factory :full_org, class: Organization do
    name "Burlingame, Easton Branch"
    street_address "1800 Easton Drive"
    zipcode "94010"
    city "Burlingame"
    state "CA"
    phones [[{ number: "650 851-1210",
               department: "Information",
               phone_hours: "(Monday-Friday, 9-12, 1-5)" }]]
    coordinates [-122.3250474, 37.568272]
    keywords ["library"]
    market_match 1
    after(:create) { |org| org.index.refresh }
  end

  factory :org_without_market_match, class: Organization do
    market_match 0
    after(:create) { |org| org.index.refresh }
  end

  factory :food_stamps_keyword, class: Organization do
    name "Samaritan House Care"
    keywords ["food stamps"]
    after(:create) { |org| org.index.refresh }
  end

  factory :food_stamps_name, class: Organization do
    name "Food Stamps"
    keywords ["child care"]
    after(:create) { |org| org.index.refresh }
  end

  factory :food_stamps_agency, class: Organization do
    name "Samaritan House"
    agency "Food Stamps"
    keywords ["CalFresh"]
    coordinates [-122.3250474, 37.568272]
    after(:create) { |org| org.index.refresh }
  end

  factory :food_stamps_description, class: Organization do
    name "Samaritan House"
    description ["We provide assistance with food stamps/SNAP"]
    after(:create) { |org| org.index.refresh }
  end
end