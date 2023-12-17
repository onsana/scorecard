class User < ApplicationRecord
  has_many :pulls
  has_many :comments
  has_many :reviews

  validates :github_id, uniqueness: true

  # TODO: date to a constant
  QUERY = <<-SQL
    WITH last_week_pulls
      AS
        (SELECT id, user_id
        FROM pulls
        WHERE date_created >= current_date at time zone 'UTC' - interval '7 days'),
      last_week_comments
      AS
        (SELECT id, user_id
        FROM comments
        WHERE date_created >= current_date at time zone 'UTC' - interval '7 days'),
      last_week_reviews
      AS
        (SELECT id, user_id
        FROM reviews
        WHERE date_created >= current_date at time zone 'UTC' - interval '7 days')
    SELECT
      users.id AS user_id,
      users.login,
      COUNT(DISTINCT last_week_pulls.id) AS pull_count,
      COUNT(DISTINCT last_week_comments.id) AS comment_count,
      COUNT(DISTINCT last_week_reviews.id) AS review_count,
      (COUNT(DISTINCT last_week_pulls.id) * 12) + (COUNT(DISTINCT last_week_comments.id) * 1) + (COUNT(DISTINCT last_week_reviews.id) * 3) AS user_rating
    FROM
      users
    LEFT JOIN
      last_week_pulls ON users.id = last_week_pulls.user_id
    LEFT JOIN
      last_week_comments ON users.id = last_week_comments.user_id
    LEFT JOIN
      last_week_reviews ON users.id = last_week_reviews.user_id
    GROUP BY
      users.id, users.login
    ORDER BY user_rating DESC;
  SQL

  # Example: [{"user_id"=>5, "login"=>"iagopiimenta", "pull_count"=>1, "comment_count"=>0, "review_count"=>0, "user_rating"=>12}]
  def self.user_ratings
    ActiveRecord::Base.connection.execute(QUERY)
  end
end
