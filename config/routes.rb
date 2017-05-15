Rails.application.routes.draw do
  scope '/api/v1' do
    resources :lists, :only => [:index, :show] do
      resources :things, :only => [:index, :show]
    end
  end

  get '/auth/:provider/callback', :to => 'sessions#create'
  get '/profile', :to => 'home#profile', :as => 'profile'
  get "/signout" => "sessions#destroy", :as => :signout
  root :to => 'home#index'
end
