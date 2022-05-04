Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "home", to: "static_pages#home", as: :home_client
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :carts, only: [:index] do
      collection do
        post "add_to_cart/:id", to: "carts#add_to_cart", as: "add_to"
      end
    end
    resources :static_pages, only: %i(index show)
    resources :users
    resources :account_activations, only: :edit
    resources :password_resets, only: %i(new create edit update)
    resources :products
    end
end
