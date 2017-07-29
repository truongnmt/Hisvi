FactoryGirl.define do
  factory :story do
    user_id nil
    category_id nil
    moments nil
    title { Faker::VentureBros.organization }
    is_public false
  end
end
