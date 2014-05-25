# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name 'Parent Agency'
  end

  factory :nearby_org, class: Organization do
    name 'Food Stamps'
  end

  factory :hsa, class: Organization do
    name 'San Mateo County Human Services Agency'
  end
end
