# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mail_address do
    street "1 davis dr"
    city "Belmont"
    state "CA"
    zip "90210"

    factory :po_box do
      street "P.O Box 123"
      city "La Honda"
      zip "94020"
    end
  end
end