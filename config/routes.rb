Rails.application.routes.draw do
  devise_for :users
  root to: "public#index"
  
  post '/set_timezone', to: 'application#set_timezone'

  resource :profile, only: [:show, :update]
  resource :timeline, only: [:update]

  resources :categories, except: :index
  get '/timer', to: 'categories#index'

  resources :periods, except: :show do
    post :run, on: :collection
    post :stop, on: :collection
  end
end
