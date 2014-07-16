# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name 'Parent Agency'

    factory :org_with_urls do
      urls %w(http://monfresh.com http://cfa.org)
    end
  end

  factory :nearby_org, class: Organization do
    name 'Food Stamps'
  end

  factory :food_pantry, class: Organization do
    name 'Food Pantry'
  end

  factory :org_with_extra_whitespace, class: Organization do
    name 'Food   Pantry  '
    urls [' http://cfa.org']
  end
end
