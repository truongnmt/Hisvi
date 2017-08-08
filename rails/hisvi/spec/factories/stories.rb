FactoryGirl.define do
  factory :story do
    user_id 1
    category_id 1
    title { Faker::VentureBros.organization }
    is_public false
  end
end
