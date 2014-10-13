# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mail_address do
    attention 'Monfresh'
    street_1 '1 davis dr'
    city 'Belmont'
    state 'CA'
    postal_code '90210'
    country_code 'US'

    factory :po_box do
      street_1 'P.O Box 123'
      city 'La Honda'
      postal_code '94020'
    end

    factory :mail_address_with_extra_whitespace do
      attention '   Moncef '
      street_1 '8875     La Honda Road'
      city 'La Honda  '
      state ' CA '
      postal_code ' 94020'
      country_code ' US '
    end
  end
end
