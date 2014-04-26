FactoryGirl.define do
  factory :service do
    name 'Burlingame, Easton Branch'
    description 'yoga classes'
    keywords ['library', 'food pantries', 'stood famps', 'emergency']
  end

  factory :service_with_nil_fields, class: Service do
    name 'Food Stamps'
    description 'SNAP market'
    keywords %w(health yoga)
    fees nil
  end
end
