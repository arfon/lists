Rails.application.routes.draw do
  scope '/' do
    resources :lists, :only => [:index, :show] do
      resources :things, :only => [:index, :show]
    end
  end

  scope '/api/v1', :as => 'api' do
    resources :lists, :only => [:index, :show] do
      resources :things, :only => [:index, :show] do
        collection do
          get 'filter'
        end
      end
    end

    resources :users, :only => [:show]
  end

  resources :users, :only => [:show]

  get '/auth/:provider/callback', :to => 'sessions#create'
  get "/signout" => "sessions#destroy", :as => :signout
  get '/about', :to => 'home#about', :as => 'about'

  root :to => 'lists#index'
end
