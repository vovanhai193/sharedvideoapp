FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username }
    email  { Faker::Internet.unique.email }
    password { '123456' }
    password_confirmation { '123456' }
  end
end
