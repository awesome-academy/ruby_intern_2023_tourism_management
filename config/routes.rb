Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "tours#index"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users, only: :show
    namespace :admin do
      resources :tours, except: %i(show delete)
    end
    resources :tours, only: %i(show index)
    resources :orders, only: :new
  end
end
