Rails.application.routes.draw do
  post 'auth/login', to: 'authentication#authenticate'

  namespace :api do
    namespace :v1 do
      namespace 'admin' do
        jsonapi_resources :users do
          get 'documents', to: 'documents#user_documents'
        end

        jsonapi_resources :documents
      end

      post 'signup', to: 'users#create'

      jsonapi_resources :users, except: :create
      jsonapi_resources :documents
    end
  end

  root to: 'home#index'
  match '*path', to: 'application#not_found', via: :all
end
