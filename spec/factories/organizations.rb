# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name "Parent Agency"
    description "SNAP market"
  end

  factory :food_stamps_agency, class: Organization do
    name "Food Stamps"
  end

  factory :food_stamps_parent, class: Organization do
    name "Namaste"
    description "We provide assistance with food stamps/SNAP"
  end

  factory :generic_agency, class: Organization do
    name "Generic Agency"
    description "Hello"
  end
end