module Github
  class CreateComment < Base
    def self.call(pull_id)
      new(pull_id).create_pull_requests_comments
    end

    def initialize(pull_id)
      @pull_id = pull_id
    end

    def get_pull_requests_comments
      client.pull_request_comments(Base::REPO, @pull_id)
    end

    def create_pull_requests_comment(comment, user_id)
      Comment.create_or_find_by(github_id: comment[:id]) do |c|
        c.date_created = comment[:created_at]
        c.user_id = user_id
      end
    end

    def create_pull_requests_comments
      get_pull_requests_comments.each do |comment|
        user = CreateUser.create_user(comment[:user])
        create_pull_requests_comment(comment, user.id)
      end
    end
  end
end
