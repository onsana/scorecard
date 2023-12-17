module Github
  class CreatePull < Base
    def self.call
      new.create_pull_requests
    end

    def create_pull_requests
      get_pull_requests.each do |pr|
        user = CreateUser.create_user(pr[:user])
        pull = create_pull_request(pr, user.id)
        CreateReview.call(pull.github_number)
        CreateComment.call(pull.github_number)
      end
    end

    private

    def get_pull_requests
      client.pull_requests(Base::REPO, {
        sort: "created",
        direction: "desc",
        since: "2023-10-01T23:45:02Z"
      })
    end

    def create_pull_request(pr, user_id)
      Pull.create_or_find_by(github_id: pr[:id]) do |p|
        p.github_number = pr[:number]
        p.date_created = pr[:created_at]
        p.user_id = user_id
      end
    end
  end
end
