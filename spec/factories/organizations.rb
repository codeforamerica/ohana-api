# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name "Burlingame, Easton Branch"
    street_address "1800 Easton Drive"
    zipcode "94010"
    city "Burlingame"
    state "CA"
    phone "650-314-5678"
    coordinates [-122.371448, 37.583849]
    keywords ["library"]
  end

  factory :nearby_org, class: Organization do
    name "Redwood City Main"
    street_address "480 Primrose Road"
    zipcode "94010"
    city "Burlingame"
    state "CA"
    coordinates [-122.348862, 37.579221]
    keywords ["library"]
  end  

  factory :farmers_market, class: Organization do
    name "Pescadero Grown"
    street_address "8875 La Honda Road"
    zipcode "94020"
    city "La Honda"
    state "CA"
    coordinates [-122.274369, 37.317983]
    keywords ["market"]
    schedule "May - November Tuesday 3:00 PM to 7:00 PM"
    urls ["http://Www.pescaderogrown.org"]
    payments_accepted ["Credit", "WIC", "SFMNP", "SNAP"]
    products_sold ["Cheese", "Flowers", "Eggs", "Seafood", "Herbs", "Vegetables", "Jams", "Meat", "Nursery", "Plants", "Poultry"]
  end

  factory :full_org, class: Organization do
    name "Burlingame, Easton Branch"
    street_address "1800 Easton Drive"
    zipcode "94010"
    city "Burlingame"
    state "CA"
    phone "650-314-5678"
    coordinates [-122.371448, 37.583849]
    latitude -122.274369
    longitude 37.317983
    keywords ["library"]
    market_match 1
  end

  factory :org_without_market_match, class: Organization do
    market_match 0
  end

end
