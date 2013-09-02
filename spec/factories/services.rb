FactoryGirl.define do
  factory :service do
    name "Burlingame, Easton Branch"
    description "yoga classes"
    keywords ["library", "food pantries", "stood famps", "emergency"]
    association :location
    after(:create) { |s| s.location.index.refresh }
  end

  factory :service_with_nil_fields, class: Service do
    name "Food Stamps"
    description "SNAP market"
    keywords ["health", "yoga"]
    fees nil
  end
end