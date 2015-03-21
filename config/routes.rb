Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  
  resources :users
end
