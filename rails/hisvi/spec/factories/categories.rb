FactoryGirl.define do
  factory :category do
    name {Faker::VentureBros.organization}
  end
end
