FactoryGirl.define do
  factory :service do
    name 'Literacy Program'
    description 'yoga classes'
    keywords ['library', 'food pantries', 'stood famps', 'emergency']
    location
  end

  factory :service_with_nil_fields, class: Service do
    name 'Food Stamps'
    description 'SNAP market'
    keywords %w(health yoga)
    fees nil
    location
  end

  factory :service_with_extra_whitespace, class: Service do
    audience 'Low-income seniors '
    description ' SNAP market'
    eligibility ' seniors '
    fees 'none '
    funding_sources ['County ']
    how_to_apply '  in  person'
    keywords ['health ', ' yoga']
    name 'Benefits '
    short_desc 'processes applications '
    service_areas ['Belmont ']
    urls [' http://www.monfresh.com ']
    wait '2 days '
    location
  end
end
