# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    street '1800 Easton Drive'
    city 'Burlingame'
    state 'CA'
    zip '94010'
  end

  factory :near, class: Address do
    street '250 Myrtle Road'
    city 'Burlingame'
    state 'CA'
    zip '94010'
  end

  factory :far, class: Address do
    street '1000 Magnolia Avenue'
    city 'Millbrae'
    state 'CA'
    zip '94030'
  end

  factory :far_west, class: Address do
    street '8875 La Honda Road'
    city 'La Honda'
    state 'CA'
    zip '94020'
  end
end
