# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    name 'VRS Services'
    description 'Provides jobs training'
    short_desc 'short description'
    accessibility [:tape_braille, :disabled_parking]
    organization
    address

    factory :location_with_admin do
      admin_emails ['moncef@smcgov.org']
    end
  end

  factory :nearby_loc, class: Location do
    name 'Library'
    description 'great books about jobs'
    short_desc 'short description'
    accessibility [:elevator]
    association :address, factory: :near
    languages %w(spanish Arabic)
    association :organization, factory: :nearby_org
  end

  factory :no_address, class: Location do
    name 'No Address'
    description 'no coordinates'
    short_desc 'short description'
    association :mail_address, factory: :po_box
    organization
  end

  factory :farmers_market_loc, class: Location do
    name 'Belmont Farmers Market'
    description 'yummy food about jobs'
    short_desc 'short description'
    association :address, factory: :far_west
    organization
  end

  factory :far_loc, class: Location do
    name 'Belmont Farmers Market'
    description 'yummy food'
    short_desc 'short description'
    association :address, factory: :far
    languages %w(spanish Arabic)
    organization
  end

  factory :loc_with_nil_fields, class: Location do
    name 'Belmont Farmers Market with cat'
    description 'yummy food'
    short_desc 'short description'
    address
    organization
    latitude 37.568272
    longitude(-122.3250474)
  end

  factory :soup_kitchen, class: Location do
    name 'Soup Kitchen'
    description 'daily hot soups'
    short_desc 'short description'
    association :address, factory: :far_west
    association :organization, factory: :food_pantry
  end
end
