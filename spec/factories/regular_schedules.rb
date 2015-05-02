FactoryGirl.define do
  factory :regular_schedule do
    weekday 7
    opens_at '9:30'
    closes_at '5pm'
  end
end
