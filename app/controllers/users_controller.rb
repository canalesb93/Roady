class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to :root, :alert => "Access denied."
    end
    @graph = Koala::Facebook::API.new(current_user.access_token)
  end

end
