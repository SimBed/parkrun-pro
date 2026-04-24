Rails.application.routes.draw do
  resources :venue_stats, only: [ :index ] do
    collection do
      get "filter"
      get "clear_filters"
    end
  end
  resources :trends, only: [ :index ] do
    collection do
      get "filter"
      get "clear_filters"
    end
  end
  resources :runs, only: [ :index ] do
    collection do
      get "filter"
      get "clear_filters"
    end
    get :close, on: :member
  end
  resources :friends, only: [ :index ]
  resources :venues
  resource :session
  resources :passwords, param: :token
  resources :users, only: [ :index ]
  namespace :charts do
    get "count_by_time"
    get "count_by_agegroup"
    get "count_by_date"
    get "fastest_time_by_date"
    get "median_time_by_date"
    get "slowest_time_by_date"
    get "avg_age_by_date"
  end
  root "runs#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
