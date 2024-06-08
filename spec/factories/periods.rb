FactoryBot.define do
  factory :period do
    self.start { "2024-01-19 11:52:56" }
    self.end { "2024-01-19 11:54:56" }
    association :category, factory: :category
    association :user, factory: :user
  end
end
