FactoryGirl.define do
  factory :regular_schedule do
    weekday 'Monday'
    opens_at '9:30'
    closes_at '5pm'
  end
end
