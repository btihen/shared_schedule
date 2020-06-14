Rails.application.routes.draw do

  resources :tenants do
    resources :spaces       # restrict routes once all routes are known
  end
  resources :spaces do
    resources :reservations # restrict routes once all routes are known
  end

  devise_for :users
  get 'landing/index'
  root to: "landing#index"
end
