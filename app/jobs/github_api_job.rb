require "sidekiq"

class GithubApiJob
  include Sidekiq::Job
  sidekiq_options retry: 5

  def perform
    Github::Base.create
  end
end
