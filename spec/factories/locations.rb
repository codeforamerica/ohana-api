# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    name 'VRS Services'
    description 'Provides jobs training'
    kind :other
    accessibility [:tape_braille, :disabled_parking]
    latitude 37.583939
    longitude(-122.3715745)
    organization
    address

    factory :location_with_admin do
      admin_emails ['moncef@smcgov.org']
    end

    factory :location_for_org_admin do
      name 'Samaritan House'
      urls ['http://samaritanhouse.com']
    end

    factory :loc_with_extra_whitespace do
      description ' Provides job training'
      hours ' Monday-Friday 10am-3pm '
      name 'VRS   Services '
      short_desc 'Provides job training. '
      transportation ' BART stop 1 block away.'
      urls [' http://samaritanhouse.com  ', 'http://samaritanhouse.com']
      admin_emails [' foo@bar.com  ', 'foo@bar.com']
      emails [' bar@foo.com  ', 'bar@foo.com']
    end
  end

  factory :nearby_loc, class: Location do
    name 'Library'
    description 'great books about jobs'
    kind :human_services
    importance 2
    accessibility [:elevator]
    latitude 37.5808591
    longitude(-122.343072)
    association :address, factory: :near
    languages %w(spanish Arabic)
    association :organization, factory: :nearby_org
  end

  factory :no_address, class: Location do
    name 'No Address'
    description 'no coordinates'
    kind :other
    association :mail_address, factory: :po_box
    organization
  end

  factory :farmers_market_loc, class: Location do
    name 'Belmont Farmers Market'
    description 'yummy food about jobs'
    market_match true
    payments %w(Credit WIC SFMNP SNAP)
    products %w(Cheese Flowers Eggs Seafood Herbs)
    kind :farmers_markets
    importance 3
    latitude 37.3180168
    longitude(-122.2743951)
    association :address, factory: :far_west
    association :organization, factory: :hsa
  end

  factory :far_loc, class: Location do
    name 'Belmont Farmers Market'
    description 'yummy food'
    kind :other
    latitude 37.6047797
    longitude(-122.3984501)
    association :address, factory: :far
    languages %w(spanish Arabic)
    organization
  end

  factory :loc_with_nil_fields, class: Location do
    name 'Belmont Farmers Market with cat'
    description 'yummy food and flute performers'
    kind :farmers_markets
    address
    organization
    latitude 37.568272
    longitude(-122.3250474)
  end

  factory :soup_kitchen, class: Location do
    name 'Soup Kitchen'
    description 'daily hot soups'
    kind :human_services
    latitude 37.3180168
    longitude(-122.2743951)
    association :address, factory: :far_west
    association :organization, factory: :food_pantry
  end
end
