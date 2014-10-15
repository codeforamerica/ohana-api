# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    street_1 '1800 Easton Drive'
    city 'Burlingame'
    state 'CA'
    postal_code '94010'
    country_code 'US'
  end

  factory :near, class: Address do
    street_1 '250 Myrtle Road'
    city 'Burlingame'
    state 'CA'
    postal_code '94010'
    country_code 'US'
  end

  factory :far, class: Address do
    street_1 '1000 Magnolia Avenue'
    city 'Millbrae'
    state 'CA'
    postal_code '94030'
    country_code 'US'
  end

  factory :far_west, class: Address do
    street_1 '8875 La Honda Road'
    city 'La Honda'
    state 'CA'
    postal_code '94020'
    country_code 'US'
  end

  factory :address_with_extra_whitespace, class: Address do
    street_1 '8875     La Honda Road'
    city 'La Honda  '
    state ' CA '
    postal_code ' 94020'
    country_code 'US '
  end
end
