Rails.application.routes.draw do
  get "/admin/home", to:"static_pages_admin#home", as: :home
  get "/admin/create", to:"static_pages_admin#create", as: :create

  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users
    resources :account_activations, only: :edit
    end
end
