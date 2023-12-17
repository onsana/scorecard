module Github
  class Base
    ACCESS_TOKEN = Rails.application.credentials.github[:secret_token]
    REPO = "rails/rails".freeze

    def self.create
      new.call
    end

    def call
      Github::CreatePull.call
    end

    private

    attr_reader :since_date

    def client
      Octokit::Client.new(access_token: ACCESS_TOKEN)
    end
  end
end
