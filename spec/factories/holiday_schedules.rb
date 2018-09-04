FactoryBot.define do
  factory :holiday_schedule do
    closed { true }
    start_date { 'December 24, 2014' }
    end_date { 'December 24, 2014' }

    trait :open do
      closed { false }
      opens_at { '9am' }
      closes_at { '17:00' }
    end
  end
end
