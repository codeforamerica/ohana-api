# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :mail_address do
    attention { 'Monfresh' }
    address_1 { '1 davis dr' }
    city { 'Belmont' }
    state_province { 'CA' }
    postal_code { '90210' }
    country { 'US' }
    association :location, factory: :no_address
  end

  factory :mail_address_with_extra_whitespace, class: 'MailAddress' do
    attention { '   Moncef ' }
    address_1 { '8875     La Honda Road' }
    city { 'La Honda  ' }
    state_province { ' CA ' }
    postal_code { ' 94020' }
    country { ' US ' }
  end
end
