FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "testing#{n}@test.com" }
    name { 'John' }
    password { '123456' }
    password_confirmation { '123456' }
  end
end
