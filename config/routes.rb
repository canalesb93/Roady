Rails.application.routes.draw do
  resources :races

  root to: 'visitors#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  
  namespace :api do
    
  end

  resources :users
end
