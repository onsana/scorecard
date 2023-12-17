class MainController < ApplicationController
  def index
    # TODO: add cache
    @users = User.user_ratings
  end
end
