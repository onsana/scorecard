FactoryBot.define do
  factory :review do
    github_id { 1 }
    user
    date_created { "2023-12-14" }
  end
end
