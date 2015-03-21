class RacesController < ApplicationController
  before_action :set_race, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @races = Race.all
    respond_with(@races)
  end

  def show
    respond_with(@race)
  end

  def new
    @race = Race.new
    respond_with(@race)
  end

  def edit
  end

  def create
    @race = Race.new(race_params)
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
      params.require(:race).permit(:name, :map_id)
    end
end
