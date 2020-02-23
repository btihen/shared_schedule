Rails.application.routes.draw do
  resources :tenants
  devise_for :users
  get 'landing/index'
  root to: "landing#index"
end
