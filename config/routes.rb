Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    # root "sessions#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users, only: :show
    namespace :admin do
      resources :tours, except: %i(show delete)
    end
    root "tours#index"
    resources :tours, only: [:show, :index]
  end
end
