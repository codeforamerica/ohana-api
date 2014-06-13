# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :phone do
    number '650 851-1210'
    department 'Information'
    extension 'x2000'
    vanity_number '800-FLY-AWAY'
  end

  factory :phone_with_missing_fields, class: Phone do
    number '650 851-1210'
    department 'Information'
  end

  factory :phone_with_extra_whitespace, class: Phone do
    number '650  851-1210 '
    department ' Information '
    extension 'x2000 '
    vanity_number ' 800-FLY-AWAY '
    number_type ' TTY '
  end
end
