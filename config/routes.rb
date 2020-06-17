Rails.application.routes.draw do

  devise_for :users
  authenticated :user do
    root to: 'planners/tenants#index', as: :authenticated_root
  end

  namespace :managers do
    root to: 'dashboard#index'
  #   # get 'dashboard/index'
  #   resources :events
  #   resources :spaces
  #   resources :categories
  #   resources :time_slots
  #   # resources :reservations
  #   # resources :tenants do
  #   #   resources :spaces
  #   # end
  #   # resources :spaces do
  #   #   resources :reservations # restrict routes once all routes are known
  #   # end
  end

  namespace :planners do
    # root to: "home#index"
    root to: 'tenants#index'
  #   resources :tenants,  only: [:index, :show] do
  #     resources :spaces, only: [:index]
  #   end
  #   resources :spaces, only: [] do
  #     resources :reservations, only: [:index, :new, :create, :edit, :update]
  #   end
  end

  # # https://devblast.com/b/rails-5-routes-scope-vs-namespace
  scope module: 'guests' do
    # root to: 'landing#index'
    resources :tenants,  only: [:index, :show] do
      resources :spaces, only: [:index, :show] # show?
    end
    resources :spaces, only: [] do
      resources :reservations, only: [:index, :new, :create, :edit, :update]
    end
  end
  root to: 'guests/landing#index'

  # resources :tenants,  only: [:index, :show] do
  #   resources :spaces, only: [:index, :show]
  # end
  # resources :spaces, only: [] do
  #   resources :reservations, only: [:index, :new, :create, :edit, :update]
  # end
  # root to: 'landing#index'

  # resources :tenants do
  #   resources :spaces
  # end
  # resources :spaces do
  #   resources :reservations
  # end
  # root to: 'landing#index'

  # get 'landing/index'
end
