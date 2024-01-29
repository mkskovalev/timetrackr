Rails.application.routes.draw do
  devise_for :users
  root to: "public#index"
  
  post '/set_timezone', to: 'application#set_timezone'

  get "/service-worker.js", to: "service_worker#service_worker"
  get "/manifest.json", to: "service_worker#manifest"

  resource :profile, only: [:show, :update]
  resource :timeline, only: [:update]
  resources :analytics, only: [:index]

  resources :categories, except: :index
  get '/tracker', to: 'categories#index'

  resources :periods, except: :show do
    post :run, on: :collection
    post :stop, on: :collection
  end
end
