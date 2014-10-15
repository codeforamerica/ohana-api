# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name 'Parent Agency'
    description 'Organization created for testing purposes'

    factory :org_with_website do
      website 'http://monfresh.com'
    end
  end

  factory :nearby_org, class: Organization do
    name 'Food Stamps'
    description 'Organization created for testing purposes'
  end

  factory :food_pantry, class: Organization do
    name 'Food Pantry'
    description 'Organization created for testing purposes'
  end

  factory :far_org, class: Organization do
    name 'Far Org'
    description 'Organization created for testing purposes'
  end

  factory :no_address_org, class: Organization do
    name 'No Address Org'
    description 'Organization created for testing purposes'
  end

  factory :org_with_extra_whitespace, class: Organization do
    name 'Food   Pantry  '
    description 'Organization created for testing purposes'
    website ' http://cfa.org'
  end
end
