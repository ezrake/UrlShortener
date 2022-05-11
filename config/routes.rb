Rails.application.routes.draw do
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
  get "/:short_url", to: "urls#long_url_redirect"
end
