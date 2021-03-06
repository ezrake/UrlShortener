Rails.application.routes.draw do
  devise_for :admins
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "urls#new"
  namespace :api do
    namespace :v1 do
      post "/short_url", to: "urls#create"
      get "/:short_url", to: "urls#long_url_redirect"
    end
  end
  post "/short_url", to: "urls#create"
  get "/urls/:id", to: "urls#show", as: "url"

  get "admin/urls", to: "admin#index"
  get "admin/urls/:id", to: "admin#show_url", as: "admin_url"

  get "/:short_url", to: "urls#long_url_redirect"
end
