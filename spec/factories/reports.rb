FactoryBot.define do
  factory :report do
    start_date { "2024-05-01 15:08:42" }
    end_date { "2024-06-01 15:08:42" }
    unique_identifier { "1234567892" }
    password { "123456" }
    association :category, factory: :category
    association :user, factory: :user

    after(:build) do |report|
      create(:period, start: report.start_date + 1.day, end: report.end_date - 1.day, category: report.category, user: report.user)
    end
  end
end
