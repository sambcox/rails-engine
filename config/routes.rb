Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        resources :find, only: :index
      end
      namespace :items do
        resources :find_all, only: :index
      end
      resources :merchants, only: [:index, :show] do
        scope module: 'merchants' do
          resources :items, only: :index
        end
      end
      resources :items do
        scope module: 'items' do
          resources :merchant, only: :index
        end
      end
    end
  end
end
