Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"

  resources :categories, except: :show

  resources :periods, except: :show do
    post :run, on: :collection
    post :stop, on: :collection
  end
end
