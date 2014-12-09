# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    name 'Food'
    taxonomy_id '101'
  end

  factory :health, class: Category do
    name 'Health'
    taxonomy_id '102'
  end

  factory :jobs, class: Category do
    name 'Jobs'
    taxonomy_id '105'
  end
end
