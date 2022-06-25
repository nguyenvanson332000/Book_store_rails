Rails.application.routes.draw do
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"
  post "create_order" => "orders#create_order"
  post "capture_order", to: "orders#capture_order"
  devise_for :users, only: %i(omniauth_callbacks registrations),
                     controllers: { omniauth_callbacks: "omniauth_callbacks", registrations: "registrations" }
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "home", to: "static_pages#home", as: :home_client
    devise_for :users, skip: :omniauth_callbacks
    # devise_for :users, controllers: { registrations: "registrations" }
    as :user do
      get "signup", to: "devise/registrations#new"
      get "login", to: "devise/sessions#new"
      delete "logout", to: "devise/sessions#destroy"
    end
    resources :carts, only: %i(index) do
      collection do
        post "add_to_cart/:id", to: "carts#add_to_cart", as: "add_to"
        put "update/:id", to: "carts#update", as: "update_to"
        delete "delete/:id", to: "carts#delete", as: "delete_from"
      end
    end
    resources :payments
    resources :static_pages, only: %i(index show) do
      member do
        get :filter_by_category
        get :filter_by_publisher
        get :filter_by_author
      end
      collection do
        get :show_product_ai
      end
    end
    resources :account_activations, only: :edit
    resources :password_resets, only: %i(new create edit update)
    resources :notifications
    resources :orders, only: %i(new create index) do
      resources :order_details, only: %i(index)
      member do
        put "update_order_status", to: "orders#update_order_status"
      end
    end
    namespace :admin do
      resources :products
      resources :orders, except: %i(create destroy) do
        member do
          put :approve
          put :reject
        end
      end
      resources :statistics, only: %i(index)
      resources :users, only: %i(index update)
      resources :categories, except: %i(show)
      resources :revenues, only: :index
      get "search_revenue", to: "revenues#search_revenue"
    end
  end
end
