Rails.application.routes.draw do
  root "merchants#index"

  get "merchants/:id/products", to: "products#merchant_product_index", as: "merchant_products"

  resources :merchants
  get "/dashboard", to: "merchants#show", as: "dashboard"

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout"

  resources :categories, only: [:index, :new, :create, :show] 
  get "categories/:id/products", to: "products#show", as: "category_products"
 
  resources :products
end
