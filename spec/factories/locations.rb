# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    address { FactoryGirl.build(:address) }
    #coordinates [-122.371448, 37.583849]
    phones [{ number: "650 851-1210",
               department: "Information",
               phone_hours: "(Monday-Friday, 9-12, 1-5)" }]
    name "VRS Services"
    description "Provides jobs training"
    kind "other"
    association :organization
    after(:create) { |loc| loc.index.refresh }
  end

  factory :address do
    street "1800 Easton Drive"
    city "Burlingame"
    state "CA"
    zip "94010"
  end

  factory :near, class: Address do
    street "250 Myrtle Road"
    city "Burlingame"
    state "CA"
    zip "94010"
  end

  factory :far, class: Address do
    street "621 Magnolia Avenue"
    city "Millbrae"
    state "CA"
    zip "94030"
  end

  factory :far_west, class: Address do
    street "8875 La Honda Road"
    city "La Honda"
    state "CA"
    zip "94020"
  end


  factory :nearby_loc, class: Location do
    name "Library"
    description "great books"
    address { FactoryGirl.build(:near) }
    #coordinates [-122.362882, 37.588935]
    languages ["spanish", "Arabic"]
    association :organization, factory: :nearby_org
    after(:create) { |loc| loc.index.refresh }
  end

  factory :no_coords, class: Location do
    name "No Address"
    description "no coordinates"
    mail_address { FactoryGirl.build(:mail_address) }
    association :organization
    after(:create) { |loc| loc.index.refresh }
  end

  factory :farmers_market_loc, class: Location do
    name "Belmont Farmers Market"
    description "yummy food"
    address { FactoryGirl.build(:far_west) }
    #coordinates [-122.274369, 37.317983]
    payments ["Credit", "WIC", "SFMNP", "SNAP"]
    products ["Cheese", "Flowers", "Eggs", "Seafood", "Herbs"]
    association :organization
    after(:create) { |loc| loc.index.refresh }
  end

  factory :far_loc, class: Location do
    name "Belmont Farmers Market"
    description "yummy food"
    address { FactoryGirl.build(:far) }
    #coordinates [-122.3250474, 37.568272]
    association :organization
    after(:create) { |loc| loc.index.refresh }
  end

  factory :loc_with_nil_fields, class: Location do
    name "Belmont Farmers Market"
    description "yummy food"
    faxes nil
    address { FactoryGirl.build(:address) }
    contacts { [FactoryGirl.build(:contact_with_nil_fields)] }
    services { [FactoryGirl.build(:service_with_nil_fields)] }
    coordinates [-122.3250474, 37.568272]
    association :organization
    after(:create) { |loc| loc.index.refresh }
  end
end