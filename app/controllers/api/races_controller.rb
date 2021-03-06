class API::RacesController < API::APIController
  before_action :set_race, only: [:show, :edit, :update, :destroy, :invite_user]

  respond_to :html

  def index
    races = current_user.races
    render json: races, status: :ok
  end

  def feed
    feeds = Milestone.order(created_at: :desc).limit(30)
    render json: feeds, status: :ok
  end

  def show
    render json: @race, include: :users 
  end

  def invite_user
    @user = User.find_by(uid: params["uid"])
    @race.user_races << UserRace.create(user_id: @user.id, race_id: @race.id)
    @race.save
    if @race.save
      render json: @race, include: :users , status: :created, location: @race
    else
      render json: @race.errors, status: 422
    end
  end

  def new
    @race = Race.new
    respond_with(@race)
  end
  def edit
  end

  def create
    @race = Race.new(race_params)
    @race.admin_name = current_user.name
    response = firebase.push("races", { name: race_params["name"] })
    @race.map_id = response.body["name"]
    @race.user_races.new(user_id: current_user.id, race_id: @race.id, accepted: true)
    if params["race"]["members"]
      params["race"]["members"].each do |friend|
        user = User.find_by(uid: friend["uid"])
        if user
          data = { alert: current_user.name.split[0...2].join(' ')+" invited you to "+@race.name, admin: current_user.name.split[0...2].join(' '), admin_uid: current_user.uid, race_name: @race.name, race: { map_id: @race.map_id, lat: @race.lat, lng: @race.lng}, type: "invitation"  }
          push = Parse::Push.new(data, "userId-"+user.uid)
          push.type = "ios"
          push.save
          @race.user_races.new(user_id: user.id, race_id: @race.id)
        end
      end
    end
    userbase = Firebase::Client.new("https://roady.firebaseio.com/races/"+@race.map_id+"/users/")
    response = userbase.set(current_user.uid, { name: current_user.name, lat: "25.649231099999998", lng: "-100.289689", distance: "140 m" })
    milebase = Firebase::Client.new("https://roady.firebaseio.com/races/"+@race.map_id)
    response = milebase.push("milestones", { name: current_user.name, message: "created the race." })

    Milestone.create(message: "created the race", name: current_user.name, uid: current_user.uid, race_name: @race.name)

    if @race.save
      render json: @race, include: :users , status: :created, location: @race
    else
      render json: @race.errors, status: 422
    end
  end

  def update
    @race.update(race_params)
    if @race.save
      render json: @race, status: 200
    else
      render json: @race.errors, status: 422
    end
  end

  def arrive
    race = current_user.user_races.where(finished: false).first.try(:race)
    race.users.each do |user|
      if user != current_user
        data = { alert: current_user.name.split[0...2].join(' ')+" reached the destination.", type: "announcement" }
        push = Parse::Push.new(data, "userId-"+user.uid)
        push.type = "ios"
        push.save
      end
    end
    head 204
  end

  def exit_race
    race = current_user.user_races.where(finished: false).first.try(:race)
    if race
      current_user.user_races.where(finished: false).first.update(finished: true)
      milebase = Firebase::Client.new("https://roady.firebaseio.com/races/"+race.map_id)
      response = milebase.push("milestones", { name: current_user.name, message: "left the race." })

      Milestone.create(message: "left the race", name: current_user.name, uid: current_user.uid, race_name: race.name)
    end
    head 204
  end

  def destroy
    @race.destroy
    head 204
  end

  # def current_race_feed
  #   race = current_user.user_races.where(finished: false).first.try(:race)
  #   userbase = Firebase::Client.new("https://roady.firebaseio.com/races/"+race.map_id, "GTxtTpOBxsVipwFroUQmMGCSxK7wYCBBGjAdAayn")
  #   response = userbase.get("users")

  #   render json: response
  # end

  private
    def set_race
      @race = Race.find(params[:id])
    end

    def race_params
      params.require(:race).permit(:name, :map_id, :lat, :lng)
    end

end
