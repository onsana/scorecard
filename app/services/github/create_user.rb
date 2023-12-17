module Github
  class CreateUser < Base
    def self.create_user(params)
      User.create_or_find_by(github_id: params[:id]) do |u|
        u.login = params[:login]
      end
    end
  end
end
