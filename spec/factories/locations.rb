# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    address { FactoryGirl.build(:address) }
    coordinates [-122.371448, 37.583849]
    phones [{ number: "650 851-1210",
               department: "Information",
               phone_hours: "(Monday-Friday, 9-12, 1-5)" }]
    name "VRS Services"
    description "Provides jobs training"
    association :organization
    after(:create) { |loc| loc.index.refresh }
  end

  factory :address do
    street "1800 Easton Drive"
    city "Burlingame"
    state "CA"
    zip "94010"
  end

  factory :nearby_loc, class: Location do
    name "Library"
    description "great books"
    address { FactoryGirl.build(:address) }
    coordinates [-122.362882, 37.588935]
    languages ["spanish", "Arabic"]
    association :organization, factory: :nearby_org
    after(:create) { |loc| loc.index.refresh }
  end

  factory :no_coords, class: Location do
    name "No Address"
    description "no coordinates"
    address { FactoryGirl.build(:address) }
    association :organization
    after(:create) { |loc| loc.index.refresh }
  end

  factory :farmers_market_loc, class: Location do
    name "Belmont Farmers Market"
    description "yummy food"
    address { FactoryGirl.build(:address) }
    coordinates [-122.274369, 37.317983]
    payments_accepted ["Credit", "WIC", "SFMNP", "SNAP"]
    products_sold ["Cheese", "Flowers", "Eggs", "Seafood", "Herbs"]
    association :organization
    after(:create) { |loc| loc.index.refresh }
  end

  factory :far_loc, class: Location do
    name "Belmont Farmers Market"
    description "yummy food"
    address { FactoryGirl.build(:address) }
    coordinates [-122.3250474, 37.568272]
    association :organization
    after(:create) { |loc| loc.index.refresh }
  end
end