Portrait::Application.routes.draw do
  resources :sites
  resources :users
  resources :customers

  root to: 'home#index'
end
