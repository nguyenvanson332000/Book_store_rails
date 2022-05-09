Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "home", to: "static_pages#home", as: :home_client
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :carts, only: %i(index) do
      collection do
        post "add_to_cart/:id", to: "carts#add_to_cart", as: "add_to"
        put "update/:id", to: "carts#update", as: "update_to"
        delete "delete/:id", to: "carts#delete", as: "delete_from"
      end
    end
    resources :static_pages, only: %i(index show)
    resources :users
    resources :account_activations, only: :edit
    resources :password_resets, only: %i(new create edit update)
    resources :orders, only: %i(new create index) do
      resources :order_details, only: %i(index)
      member do
        put "update_order_status", to: "orders#update_order_status"
      end
    end
    namespace :admin do
      resources :products
      resources :orders, except: %i(create destroy)
    end
  end
end
