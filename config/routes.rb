Rails.application.routes.draw do
  post 'auth/login', to: 'authentication#authenticate'

  namespace :api do
    namespace :v1 do

      post 'signup', to: 'users#create'

      jsonapi_resources :users, except: :create
      jsonapi_resources :documents
    end
  end

  root to: 'home#index'
  match '*path', to: 'application#not_found', via: :all
end
