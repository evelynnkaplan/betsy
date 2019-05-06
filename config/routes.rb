Rails.application.routes.draw do
  root "homepages#home"

  get "merchants/:id/products", to: "products#merchant_product_index", as: "merchant_products"

  resources :merchants
  get "/dashboard", to: "merchants#show", as: "dashboard"

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout"

  resources :categories, only: [:index, :new, :create, :show] 
  get "categories/:id/products", to: "products#category_product_index", as: "category_products"
 
  resources :products do
    resources :reviews, only: [:new, :create]
  end

  resources :orders, except: [:new, :destroy]
  get 'orders/view_cart', to: 'orders#view_cart', as: 'view_cart'

  resources :order_items, only: [:create, :update, :destroy]
end
