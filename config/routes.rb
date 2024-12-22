Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api_v1, path: 'v1' do
    namespace :user do
      post :sign_up, action: :sign_up
      post :login, action: :login
    end

    namespace :wallet do
      post :deposit, action: :deposit
    end
  end
end
