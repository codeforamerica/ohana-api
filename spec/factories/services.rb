FactoryGirl.define do
  factory :service do
    name 'Literacy Program'
    description 'yoga classes'
    how_to_apply 'By phone.'
    keywords ['library', 'food pantries', 'stood famps', 'emergency']
    status 'active'
    location
  end

  factory :service_with_extra_whitespace, class: Service do
    accepted_payments [' Cash', 'Credit ']
    alternate_name 'AKA '
    audience 'Low-income seniors '
    description ' SNAP market'
    eligibility ' seniors '
    email ' foo@example.com '
    fees 'none '
    funding_sources ['County ', 'County']
    how_to_apply '  in  person'
    keywords ['health ', ' yoga', 'yoga']
    languages ['French ', ' English']
    name 'Benefits '
    required_documents ['ID ']
    service_areas ['Belmont ', 'Belmont']
    status 'active'
    website ' http://www.monfresh.com '
    wait '2 days '
    location
  end
end
