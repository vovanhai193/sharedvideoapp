FactoryBot.define do
  factory :like do
    user { create(:user) }
    video { create(:video) }
    is_like { true }
  end
end
