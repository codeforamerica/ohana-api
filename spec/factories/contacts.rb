# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact do
    name 'Moncef Belyamani'
    title 'CTO'

    factory :foobar do
      name 'Foo'
      title 'Bar'
    end

    factory :contact_with_extra_whitespace do
      name 'Foo '
      title ' Bar'
      email '  foo@bar.com '
      fax '123-456-7890 '
      phone '  123-456-7890 '
      extension 'x1234  '
    end
  end
end
