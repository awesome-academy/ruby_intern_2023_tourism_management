Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "tours#index"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users do
      resources :orders, only: :index
    end
    namespace :admin do
      resources :tours, except: %i(show delete)
      resources :orders, only: %i(index update)
    end
    resources :tours, only: %i(show index)
    resources :orders, only: %i(new create update)
  end
end
