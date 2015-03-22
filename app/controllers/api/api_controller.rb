class API::APIController < ApplicationController

  def current_user
    @current_user ||= User.find_for_facebook_oauth(request.headers["Authorization"])
  end

end
