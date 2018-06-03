Rails.application.routes.draw do
  post 'auth/login', to: 'authentication#authenticate'

  namespace 'api' do
    namespace 'v1' do
      resources :users, :except => [:create] do
        resources :documents
      end

      post 'signup', to: 'users#create'

    end
  end

  match '*path', to: 'application#not_found', via: :all
end
