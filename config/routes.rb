require 'sidekiq/web'

Portrait::Application.routes.draw do
  devise_for :users

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    get 'logout', to: 'devise/sessions#destroy'
    get 'signup', to: 'devise/registrations#new'
  end

  resources :sites, only: [:index, :show]

  namespace :admin do
    resources :users
    resources :sites, only: [:index, :create]
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :api do
    namespace :v1 do
      resources :sites, only: [:index, :show, :create]
    end
  end

  get  '/'=>'home#index', as: 'root'
end