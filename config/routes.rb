Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"

  resources :categories

  resources :periods do
    post :run, on: :collection
    post :stop, on: :collection
  end
  
end
