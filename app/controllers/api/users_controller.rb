class API::UsersController < API::APIController

  def friends
    # graph = Koala::Facebook::API.new(current_user.access_token)
    # friends = []
    # graph.get_connections("me", "friends").each do |friend|
    #   byebug
    #   user = User.find_by(uid: friend["id"])
    #   if user
    #     friends << user 
    #   end
    # end
    render json: User.all, status: :ok
  end

  def current_race
    user_race = current_user.user_races.where(finished: false).first
    race = user_race.try(:race)
    if race
      render json: { race: race, accepted: user_race.accepted, admin_uid: current_user.uid }, include: :users
    else
      head 204
    end
  end

  def buzz_race
    race = current_user.user_races.where(finished: false).first.try(:race)
    race.users.each do |user|
      if user != current_user
        data = { alert: current_user.name.split[0...2].join(' ')+" buzzed you.", type: "buzz" }
        push = Parse::Push.new(data, "userId-"+user.uid)
        push.type = "ios"
        push.save
      end
    end
    head 204
  end

  def accept_race
    user_race = current_user.user_races.where(finished: false, accepted: false).first
    race = user_race.try(:race)
    if race
      user_race.update(accepted: true)
      milebase = Firebase::Client.new("https://roady.firebaseio.com/races/"+race.map_id)
      response = milebase.push("milestones", { name: current_user.name, message: "joined the race." })
      Milestone.create(message: "joined the race", name: current_user.name, uid: current_user.uid, race_name: race.name)
    end
    render json: { race: race, accepted: user_race.accepted, admin_uid: current_user.uid }, include: :users
  end
end
