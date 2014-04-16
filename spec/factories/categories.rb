# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    name "Food"
    oe_id "101"
  end

  factory :health, class: Category do
    name "Health"
    oe_id "102"
  end

  factory :jobs, class: Category do
    name "Jobs"
    oe_id "105"
  end
end
