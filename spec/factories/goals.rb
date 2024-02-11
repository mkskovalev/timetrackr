FactoryBot.define do
  factory :goal do
    duration { 60 }
    schedule { "daily" }
    user
    category
  end
end
