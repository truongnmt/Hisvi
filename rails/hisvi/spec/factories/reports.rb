FactoryGirl.define do
  factory :report do
    user_id nil
    story_id nil
    content { Faker::Job.field }
  end
end
