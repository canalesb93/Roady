class API::UsersController < API::APIController

  def friends
    graph = Koala::Facebook::API.new(current_user.access_token)
    friends = []
    graph.get_connections("me", "friends").each do |friend|
      user = User.find_by(uid: friend["id"])
      if user
        friends << user 
      end
    end
    render json: friends, status: :ok
  end

end
