Portrait::Application.routes.draw do
  get 'sessions/new'
  post 'sessions/create'
  get 'sessions/destroy'
  resources :sites
  resources :users
  resources :customers

  root to: 'home#index'
end
