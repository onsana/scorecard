class Pull < ApplicationRecord
  belongs_to :user
  validates :github_id, uniqueness: true
  validates :github_number, uniqueness: true
end
