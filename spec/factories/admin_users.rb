# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin_user do
    email "admin@example.com"
    password "changeme"
    password_confirmation "changeme"
    role "admin"
  end

  factory :admin_editor, :class => :admin_user do
    email "editor@example.com"
    password "changeme"
    password_confirmation "changeme"
    role "editor"
  end
end
