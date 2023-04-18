FactoryBot.define do
  factory :video do
    youtube_url { Faker::Internet.url(host: 'youtube.com') }
    user { create(:user) }
    title { Faker::Movie.title }
    description { Faker::Movie.quote }
    youtube_id { Faker::Internet.uuid }
  end
end
