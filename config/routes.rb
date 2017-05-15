Rails.application.routes.draw do
  resources :lists


  get '/auth/:provider/callback', :to => 'sessions#create'
  get '/profile', :to => 'home#profile', :as => 'profile'
  get "/signout" => "sessions#destroy", :as => :signout
  root :to => 'home#index'
end
