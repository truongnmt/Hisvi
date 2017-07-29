FactoryGirl.define do
  factory :moment do
    story_id nil
    content { Faker::HowIMetYourMother.quote }
    is_completed nil
  end
end
