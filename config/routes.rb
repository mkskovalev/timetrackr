Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"

  post '/set_timezone', to: 'application#set_timezone'

  resources :categories

  resources :periods, except: :show do
    post :run, on: :collection
    post :stop, on: :collection
  end
end
