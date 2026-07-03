Rails.application.routes.draw do
  get "pages/about"
  get "about" => "pages#about"
  resources :venue_stats, only: [ :index ] do
    get "clear_filters", on: :collection
  end
  resources :best_times, only: [ :index ] do
    get "clear_filters", on: :collection
  end
  resources :trends, only: [ :index ]
  resources :runs, only: [ :index ], param: :venue do
    get :clear_filters, on: :collection
    get :close, on: :member
  end
  resources :friends, only: [ :index ]
  resources :venues, except: [ :show, :destroy ]
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
    get "over80s_by_date"
    get "over90s_by_date"
    get "fastest_time_by_agegroup_male"
    get "fastest_time_by_agegroup_female"
    get "fastest_time_by_agegroup"
  end
  root "pages#about"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # route to ping to keep DB connections alive on homeserver
  get "/health", to: proc { ActiveRecord::Base.connection.execute("SELECT 1")
                            [ 200, {}, [ "OK" ] ]
                          }, as: :ping_to_keep_app_awake
end
