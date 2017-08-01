email = Faker::Internet.email
p "seeding users"
User.create! email: email,
  password: "123123",
  reset_password_sent_at: "",
  remember_created_at: "",
  last_sign_in_at: "",
  current_sign_in_ip: "",
  last_sign_in_ip: "",
  bio: Faker::HarryPotter.quote,
  is_admin: true

99.times do |n|
  email2 = Faker::Internet.email
  User.create! email: email2,
    password: "password",
    reset_password_sent_at: "",
    remember_created_at: "",
    last_sign_in_at: "",
    current_sign_in_ip: "",
    last_sign_in_ip: "",
    bio: Faker::HarryPotter.quote,
    is_admin: false
end

p "seeding categories"
Category.create!name: "Travel"
Category.create!name: "Book"
Category.create!name: "Fashion"
Category.create!name: "Nature"
Category.create!name: "Food"

p "take first 10 users, each user has 10 stories, random on is_public"
users = User.order(:created_at).take 10
# take first 10 users, each user has 10 stories, random on is_public
10.times do
  title = Faker::VentureBros.organization
  users.each { |user|
    title = Faker::VentureBros.organization
    story = user.stories.create!(category_id: rand(1..5),
      title: title,
      is_public: [true, false].sample)

    # each story has 5 moments, random on is_completed
    5.times do
      content = Faker::HowIMetYourMother.quote
      story.moments.create!(content: content,
        is_completed: [true, false].sample)
    end
  }
end

p "each story random from 0->10 likes, random user like"
stories = Story.all
stories.each {|story|
  rand(0..10).times do
    Like.create!(user_id: rand(1...100), story_id: story.id)
  end
}


p "each story random from 0->7 comments, random user comment"
stories.each { |story|
  rand(0..7).times do
    content = Faker::Hacker.say_something_smart
    Comment.create! user_id: rand(1...100), story_id: story.id,
      content: content
  end
}

p "random report 5 stories by random user"
stories = Story.order("random()").take 5
stories.each { |story|
  content = Faker::Hipster.sentence
  Report.create!(user_id: rand(1...100),
    story_id: story.id, content: content)
}

p "first user follow user_id 2->50, followed by user_id 3->40"
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
