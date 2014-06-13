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

  factory :service_with_extra_whitespace, class: Service do
    audience 'Low-income seniors '
    description ' SNAP market'
    eligibility ' seniors '
    fees 'none '
    how_to_apply '  in  person'
    keywords ['health ', ' yoga']
    name 'Benefits '
    short_desc 'processes applications '
    wait '2 days '
  end
end
