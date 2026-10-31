Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api do
    namespace :v1 do
      post   "auth/signup", to: "auth#signup"
      post   "auth/login",  to: "auth#login"
      delete "auth/logout", to: "auth#logout"
      get    "auth/me",     to: "auth#me"

      resources :restaurants

      resources :menu_items

      resources :expenses

      get "recommendations", to: "recommendations#index"
    end
  end
end
