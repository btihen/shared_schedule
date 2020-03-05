Rails.application.routes.draw do
  resources :tenants do
    resources :spaces do
      resources :reservations # restrict routes once all routes are known
    end
  end
  devise_for :users
  get 'landing/index'
  root to: "landing#index"
end
