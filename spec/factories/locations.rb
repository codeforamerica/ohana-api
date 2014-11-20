# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    name 'VRS Services'
    description 'Provides jobs training'
    short_desc 'short description'
    accessibility [:tape_braille, :disabled_parking]
    latitude 37.583939
    longitude(-122.3715745)
    organization
    address

    factory :location_with_admin do
      admin_emails ['moncef@smcgov.org']
      association :organization, factory: :nearby_org
    end

    factory :location_for_org_admin do
      name 'Samaritan House'
      website 'http://samaritanhouse.com'
      association :organization, factory: :far_org
    end

    factory :loc_with_extra_whitespace do
      description ' Provides job training'
      name 'VRS   Services '
      short_desc 'Provides job training. '
      transportation ' BART stop 1 block away.'
      website ' http://samaritanhouse.com  '
      admin_emails [' foo@bar.com  ', 'foo@bar.com']
      email ' bar@foo.com  '
      languages [' English', 'Vietnamese ']
    end
  end

  factory :nearby_loc, class: Location do
    name 'Library'
    description 'great books about jobs'
    short_desc 'short description'
    accessibility [:elevator]
    latitude 37.5808591
    longitude(-122.343072)
    association :address, factory: :near
    languages %w(Spanish Arabic)
    association :organization, factory: :nearby_org
  end

  factory :no_address, class: Location do
    name 'No Address'
    description 'no coordinates'
    short_desc 'short description'
    virtual true
    association :organization, factory: :no_address_org
  end

  factory :farmers_market_loc, class: Location do
    name 'Belmont Farmers Market'
    description 'yummy food about jobs'
    short_desc 'short description'
    latitude 37.3180168
    longitude(-122.2743951)
    languages %w(French Tagalog)
    association :address, factory: :far_west
    association :organization, factory: :food_pantry
  end

  factory :far_loc, class: Location do
    name 'Belmont Farmers Market'
    description 'yummy food'
    short_desc 'short description'
    latitude 37.6047797
    longitude(-122.3984501)
    association :address, factory: :far
    languages %w(Spanish Arabic)
    association :organization, factory: :far_org
  end

  factory :loc_with_nil_fields, class: Location do
    name 'Belmont Farmers Market with cat'
    description 'yummy food'
    short_desc 'short description'
    address
    latitude 37.568272
    longitude(-122.3250474)
    association :organization, factory: :far_org
  end

  factory :soup_kitchen, class: Location do
    name 'Soup Kitchen'
    description 'daily hot soups'
    short_desc 'short description'
    latitude 37.3180168
    longitude(-122.2743951)
    association :address, factory: :far_west
    association :organization, factory: :food_pantry
  end
end
