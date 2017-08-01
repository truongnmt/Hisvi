FactoryGirl.define do
  factory :comment do
    user_id nil
    story_id nil
    content { Faker::Hobbit.quote }
  end
end
