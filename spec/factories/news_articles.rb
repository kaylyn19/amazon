FactoryBot.define do
  factory :news_article do
    title {Faker::Job.title}
    description {Faker::Job.field}
    # published_at {}
    # view_count {}
    association :user, factory: :user
  end
end
