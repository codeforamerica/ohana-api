# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :program do
    name "Burlingame, Easton Branch"
    description "yoga classes"
    urls ["http://Www.pescaderogrown.org"]
    association :organization
  end

  factory :food_stamps_program, class: Program do
    name "Food Stamps"
    description "SNAP market"
    association :organization
  end
end