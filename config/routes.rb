Portrait::Application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  resources :sites
  resources :users

  root to: 'sites#index'

  get   '/signup', to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  get '/logout',  to: 'sessions#destroy'
  resources :password_resets,     only: [:new, :create, :edit, :update]

end
