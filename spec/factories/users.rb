FactoryBot.define do
  factory :user do
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    sequence :email do |n|
      Faker::Internet.email.sub("@", "-#{n}@")
    end
    password {'password'}
  end
end
