# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    address { FactoryGirl.build(:address) }
    coordinates [-122.371448, 37.583849]
    keywords ["library", "food stamps"]
    phones [{ number: "650 851-1210",
               department: "Information",
               phone_hours: "(Monday-Friday, 9-12, 1-5)" }]
    association :program
    program_name "Burlingame, Easton Branch"
  end

  factory :address do
    street "1800 Easton Drive"
    city "Burlingame"
    state "CA"
    zip "94010"
  end

  factory :nearby_loc, class: Location do
    address { FactoryGirl.build(:address) }
    coordinates [-122.362882, 37.588935]
    keywords ["nearby"]
    program_name "Food Stamps"
    association :program, factory: :food_stamps_program
  end

  factory :no_address, class: Location do
    keywords ["library"]
    association :program
  end

  factory :farmers_market_loc, class: Location do
    address { FactoryGirl.build(:address) }
    coordinates [-122.274369, 37.317983]
    keywords ["market"]
    program_name "Pescadero Grown"
    payments_accepted ["Credit", "WIC", "SFMNP", "SNAP"]
    products_sold ["Cheese", "Flowers", "Eggs", "Seafood", "Herbs"]
    association :program, factory: :program
  end
end