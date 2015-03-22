Rails.application.routes.draw do

  root to: 'visitors#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  resources :races
  post 'races/:id/invite', to: 'races#invite_user'

  
  namespace :api do
    resources :races
    post 'races/:id/invite', to: 'races#invite_user'
    get 'users/friends', to: 'users#friends'
    get 'users/current_race', to: 'users#current_race'
    
  end

  resources :users
end
