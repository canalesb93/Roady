class API::APIController < ApplicationController

  # before_filter :basic_auth

  def basic_auth
    authenticate_or_request_with_http_basic do |username,password|
      resource = User.find_by_email(username)
      if resource.valid_password?(password)
        sign_in :user, resource
      end
    end
  end

  # def authenticate_token!
  #   authenticate || render_unauthorized
  # end

  # def authenticate
  #   authenticate_with_http_token do |token, options|
  #     @current_user = User.find_by(authentication_token: token)
  #   end    
  # end

  # def render_unauthorized
  #   self.headers['WWW-Authenticate'] = 'Token realm="Application"'
  #   respond_to do |format|
  #     format.json { render json: 'Bad credentials', status: 401 }
  #     format.xml { render xml: 'Bad credentials', status: 401 }
  #   end
  # end
end
