class API::RacesController < API::APIController
  before_action :set_race, only: [:show, :edit, :update, :destroy, :invite_user]

  respond_to :html

  def index
    races = current_user.races
    render json: races, status: :ok
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
    @race.user_races.new(user_id: current_user.id, race_id: @race.id)
    params["race"]["members"].each do |friend|
      user = User.find_by(uid: friend["uid"])
      if user
        @race.user_races.new(user_id: user.id, race_id: @race.id)
      end
    end
    response = firebase.push("races", { name: race_params["name"] })
    @race.map_id = response.body["name"]
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

  def exit_race
    Race.where(finished: false).first.update(finished: true)
    head 204
  end

  def destroy
    @race.destroy
    head 204
  end

  private
    def set_race
      @race = Race.find(params[:id])
    end

    def race_params
      params.require(:race).permit(:name, :map_id, :lat, :lng)
    end

end
