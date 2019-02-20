FactoryGirl.define do
  factory :event do
    title 'Test Event'
    posted_at '2019-01-06 18:30:00'
    starting_at '2019-01-06 18:30:00'
    ending_at '2019-01-06 22:30:00'
    city 'Los Angeles'
    is_featured false
    street_1 'Test street'
    user
    organization
  end
end
