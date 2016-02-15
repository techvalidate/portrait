Portrait::Application.routes.draw do
  devise_for :users

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    get 'logout', to: 'devise/sessions#destroy'
    get 'signup', to: 'devise/registrations#new'
  end

  resources :sites, only: [:index, :show] do
    post 'api', on: :collection
  end

  namespace :admin do
    resources :users
    resources :sites, only: [:index, :create]
  end


  post '/'=>'sites#api',  as: 'api'
  get  '/'=>'home#index', as: 'root'
end