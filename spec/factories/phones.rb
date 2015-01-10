# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :phone do
    number '650 851-1210'
    number_type 'voice'
    extension '200'
  end

  factory :phone_with_extra_whitespace, class: Phone do
    country_prefix '33 '
    number '650  851-1210 '
    department ' Information '
    extension '2000 '
    vanity_number ' 800-FLY-AWAY '
  end
end
