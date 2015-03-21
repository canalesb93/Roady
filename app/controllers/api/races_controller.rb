class API::RacesController < API::APIController
  before_action :set_race, only: [:show, :edit, :update, :destroy, :invite_user]

  respond_to :html

  def index
    # races = current_user.races
    races = Race.all
    render json: races, status: :ok
  end

  def show
    @graph = Koala::Facebook::API.new(current_user.access_token)
    respond_with(@race)
  end

  def invite_user
    @race.user_races << UserRace.create(user_id: params[:invite][:user_id], race_id: @race.id)
    @race.save
    respond_to do |format|
      format.js
    end
  end

  def new
    @race = Race.new
    respond_with(@race)
  end

  def edit
  end

  def create
    @race = Race.create(race_params)
    @race.user_races << UserRace.create(user_id: current_user.id, race_id: @race.id)
    @race.save
    respond_with(@race)
  end

  def update
    @race.update(race_params)
    respond_with(@race)
  end

  def destroy
    @race.destroy
    respond_with(@race)
  end

  private
    def set_race
      @race = Race.find(params[:id])
    end

    def race_params
      params.require(:race).permit(:name, :map_id, :lat, :lng)
    end

    def user_race_params
      params.require(:race).permit(:user_id)
    end
end
