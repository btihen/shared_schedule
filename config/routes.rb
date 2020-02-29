Rails.application.routes.draw do
  resources :tenants do
    resources :spaces
  end
  devise_for :users
  get 'landing/index'
  root to: "landing#index"
end
