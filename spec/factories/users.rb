FactoryBot.define do
  sequence :email do |n|
    "test#{n}_#{rand(1000..9999)}@mail.com"
  end

  factory :user do
    email
    password { '1234567' }
    password_confirmation { '1234567' }

    trait :confirmed do
      confirmed_at { 'Wed, 07 Dec 2022 15:27:42 UTC +00:00' }
    end
  end
end
