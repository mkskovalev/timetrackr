FactoryBot.define do
  factory :report do
    user { nil }
    category { nil }
    start_date { "2024-06-01 15:08:42" }
    end_date { "2024-06-01 15:08:42" }
    unique_identifier { "MyString" }
    password_digest { "MyString" }
  end
end
