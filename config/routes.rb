Rails.application.routes.draw do
  resources :merchants #show is restricted because it serves as the merchant dashboard
  # /merchants/:id/products <- Merchant's shop
  # get "/auth/github", as: "github_login"
  # get "/auth/:provider/callback", to: "users#create"
  # delete "/logout", to: "merchants#logout", as: "logout"

  resources :products
end
