Rails.application.routes.draw do
  get "home/index"
  get "home/update_feeds"
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :registrations, except: [ :index, :show, :destroy ]

  resources :feeds do
    member do
      patch :update_articles
      patch :toggle_pause
    end
  end

  resources :articles do
    patch :toggle_status, on: :member
    post :summary, on: :member
  end

  resources :users do
    member do
      get :profile
      post :import_via_opml
      delete :clear_old_articles
    end

    collection do
      get :export_opml
      patch :update_api_key
    end
  end

  resources :folders do
    get :refresh_feed, on: :member
    patch :mark_all_as_read, on: :member
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root to: "home#index"
end
