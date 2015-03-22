Rails.application.routes.draw do

  root to: 'visitors#index'
  get 'feed', to: 'visitors#feed'
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  resources :races
  post 'races/:id/invite', to: 'races#invite_user'

  
  namespace :api do
    get 'races/feed', to: 'races#feed'
    # get 'races/current_race_feed', to: 'races#current_race_feed'
    resources :races
    post 'races/:id/invite', to: 'races#invite_user'
    get 'users/friends', to: 'users#friends'
    get 'users/buzz_race', to: 'users#buzz_race'
    get 'users/current_race', to: 'users#current_race'
    get 'users/pebble_current_race', to: 'users#pebble_current_race'
    post 'users/accept_race', to: 'users#accept_race'
    post 'races/exit_race', to: 'races#exit_race'
    post 'races/arrive', to: 'races#arrive'
  end
  resources :users

end
