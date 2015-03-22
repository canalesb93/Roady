class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def firebase
    firebase = Firebase::Client.new('https://roady.firebaseio.com/')
  end
end
