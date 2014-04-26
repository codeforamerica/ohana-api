# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact do
    name 'Moncef Belyamani'
    title 'CTO'

    factory :foobar do
      name 'Foo'
      title 'Bar'
    end
  end
end
