Rails.application.routes.draw do

  root to: 'visitors#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  resources :races
  post 'races/:id/invite', to: 'races#invite_user'

  
  namespace :api do
    resources :races
    post 'races/:id/invite', to: 'races#invite_user'
    
  end

  resources :users
end
