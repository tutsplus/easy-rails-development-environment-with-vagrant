
Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :contacts, except: :show do
    post :generate, on: :collection
  end

  root 'contacts#index'
end
