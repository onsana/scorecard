module Github
  class CreateReview < Base
    def self.call(pull_id)
      new(pull_id).create_pull_request_reviews
    end

    def initialize(pull_id)
      @pull_id = pull_id
    end

    def create_pull_request_review(review, user_id)
      Review.create_or_find_by(github_id: review[:id]) do |r|
        r.date_created = review[:submitted_at]
        r.user_id = user_id
      end
    end

    def create_pull_request_reviews
      reviews = get_pull_request_reviews(@pull_id)
      reviews.each do |review|
        user = CreateUser.create_user(review[:user])
        create_pull_request_review(review, user.id)
      end
    end

    def get_pull_request_reviews(pull_id)
      client.pull_request_reviews(Base::REPO, pull_id)
    end
  end
end
