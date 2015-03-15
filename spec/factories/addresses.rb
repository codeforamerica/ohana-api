# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    address_1 '1800 Easton Drive'
    city 'Burlingame'
    state_province 'CA'
    postal_code '94010'
    country 'US'
  end

  factory :near, class: Address do
    address_1 '250 Myrtle Road'
    city 'Burlingame'
    state_province 'CA'
    postal_code '94010'
    country 'US'
  end

  factory :far, class: Address do
    address_1 '1000 Magnolia Avenue'
    city 'Millbrae'
    state_province 'CA'
    postal_code '94030'
    country 'US'
  end

  factory :far_west, class: Address do
    address_1 '8875 La Honda Road'
    city 'La Honda'
    state_province 'CA'
    postal_code '94020'
    country 'US'
  end

  factory :address_with_extra_whitespace, class: Address do
    address_1 '8875     La Honda Road'
    city 'La Honda  '
    state_province ' CA '
    postal_code ' 94020'
    country 'US '
  end
end
