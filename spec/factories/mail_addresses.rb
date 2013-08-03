# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mail_address do
    street "1 davis dr"
    city "Belmont"
    state "CA"
    zip "90210"
  end
end