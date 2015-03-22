class API::UsersController < API::APIController

  def friends
    graph = Koala::Facebook::API.new(current_user.access_token)
    friends = []
    graph.get_connections("me", "friends").each do |friend|
      friends << User.find_by(uid: friend["id"])
    end
    render json: friends, status: :ok
  end

end
