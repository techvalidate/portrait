Portrait::Application.routes.draw do
  resources :roles
  resources :groups
  resources :sites

  resources :users

  resources :users_groups
  resources :users_roles

  resources :password_resets

  root to: 'home#index'
end
