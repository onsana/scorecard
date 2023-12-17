FactoryBot.define do
  factory :pull do
    github_id { 1 }
    user
    github_number { 1 }
    date_created { "2023-12-14" }
  end
end
