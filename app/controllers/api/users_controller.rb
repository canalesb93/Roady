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

  def current_race
    render json: current_user.user_races.where(finished: false).first.try(:race), include: :users
  end

  def accept_race
    race = current_user.user_races.where(finished: false, accepted: false).first.try(:race)
    if race
      current_user.user_races.where(finished: false, accepted: false).first.update(accepted: true)
      milebase = Firebase::Client.new("https://roady.firebaseio.com/races/"+race.map_id)
      response = milebase.push("milestones", { name: current_user.name, message: "joined the race." })
    end

    head 204
  end
end
