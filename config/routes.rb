Rails.application.routes.draw do
  root "merchants#index"
  
  resources :merchants #show is restricted because it serves as the merchant dashboard
  # /merchants/:id/products <- Merchant's shop
  
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: 'auth_callback'
  # delete "/logout", to: "merchants#logout", as: "logout"

  resources :products 
end
