Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end  

  scope "(:locale)", locale: /en|ru/ do
    devise_for :users, controllers: { registrations: 'registrations' }
    root to: 'public#index', as: :localized_root
  end

  root to: 'categories#index'
  
  post :set_timezone, to: 'application#set_timezone'

  get "/service-worker.js", to: "service_worker#service_worker"
  get "/manifest.json", to: "service_worker#manifest"

  namespace :admin do
    resources :users, only: :index
  end

  resource :profile, only: [:show, :update]
  resource :timeline, only: [:update]

  resources :analytics, only: [:index] do
    collection do
      post '/get-chart-donut-time-categories-data', to: 'analytics#chart_donut_time_categories_data'
      post '/get-chart-bar-hourly-activity-data', to: 'analytics#chart_bar_hourly_activity_data'
    end
  end

  resources :categories, except: :index do
    patch :update_position, on: :member
  end
  get :tracker, to: 'categories#index'

  resources :periods, except: :show do
    post :run, on: :collection
    post :stop, on: :collection
  end

  resources :goals
end
