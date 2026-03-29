Rails.application.routes.draw do
  resources :venue_stats, only: [ :index ] do
    collection do
      get "filter"
      get "clear_filters"
    end
  end
  resources :runs do
    collection do
      get "filter"
      get "clear_filters"
    end
  end
  resources :venues
  resource :session
  resources :passwords, param: :token
  resources :users, only: [ :index ]
  root "runs#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
