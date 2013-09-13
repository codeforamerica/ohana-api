# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact do
    name "Moncef Belyamani"
    title "CTO"
  end

  factory :contact_with_nil_fields, class: Contact do
    name "Moncef"
    title "Chief Fun Officer"
    email nil
  end
end