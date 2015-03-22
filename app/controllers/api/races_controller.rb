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
    render json: @race, include: :users 
  end

  def invite_user
    # @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])
    # @race.user_races << UserRace.create(user_id: params[:user_id], race_id: @race.id)
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
    @race = Race.create(race_params)
    @race.user_races << UserRace.create(user_id: current_user.id, race_id: @race.id)

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
