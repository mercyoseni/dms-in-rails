Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :users
    end
  end

  match '*path', to: 'application#not_found', via: :all
end
