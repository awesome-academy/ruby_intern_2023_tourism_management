Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "tours#index"
    devise_for :users
    as :user do
      get "login", to: "devise/sessions#new"
      post "login", to: "devise/sessions#create"
      delete "logout", to: "devise/sessions#destroy"
    end
    resources :users do
      resources :orders, only: :index
    end
    namespace :admin do
      resources :tours, except: %i(delete)
      resources :orders, only: %i(index update)
    end
    resources :tours, only: %i(show index)
    resources :orders, only: %i(new create update)
    resources :comments, only: %i(create update destroy)
  end
end
