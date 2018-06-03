Rails.application.routes.draw do
  post 'auth/login', to: 'authentication#authenticate'

  namespace 'api' do
    namespace 'v1' do
      resources :users, :except => [:create]
      resources :documents

      post 'signup', to: 'users#create'

    end
  end

  match '*path', to: 'application#not_found', via: :all
end
