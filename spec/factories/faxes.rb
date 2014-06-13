# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :fax do
    number '703-555-1212'
    department 'Parks & Recreation'
  end

  factory :fax_with_no_dept, class: Fax do
    number '800-222-3333'
  end

  factory :fax_with_extra_whitespace, class: Fax do
    number '  800-222-3333  '
    department '  Department of Corrections  '
  end
end
