FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "password"
    reset_password_token nil
    reset_password_sent_at nil
    remember_created_at nil
    current_sign_in_at nil
    last_sign_in_at nil
    current_sign_in_ip nil
    last_sign_in_ip nil
    bio { Faker::HarryPotter.quote }
    is_admin false
  end
end
