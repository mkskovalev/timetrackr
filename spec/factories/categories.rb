FactoryBot.define do
  sequence :category_name do |n|
    "MyCategory#{n}"
  end

  factory :category do
    name { generate(:category_name) }
    association :user, factory: :user
  end
end
