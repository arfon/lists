Rails.application.routes.draw do
  scope '/' do
    resources :lists, :only => [:index, :show] do
      resources :things, :only => [:index, :show]
    end
  end

  scope '/api/v1', :as => 'api' do
    resources :lists, :only => [:index, :show] do
      resources :things, :only => [:index, :show]
    end
  end

  resources :users, :only => [:show]

  get '/auth/:provider/callback', :to => 'sessions#create'
  get '/profile', :to => 'home#profile', :as => 'profile'
  get "/signout" => "sessions#destroy", :as => :signout

  # General application routes
  get '/about', :to => 'lists#about', :as => 'about'

  root :to => 'lists#index'
end
