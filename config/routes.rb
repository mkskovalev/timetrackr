Rails.application.routes.draw do
  
  scope "(:locale)", locale: /en|ru/ do
    devise_for :users, controllers: { registrations: 'registrations' }
    root to: 'public#index', as: :localized_root
  end
  
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
