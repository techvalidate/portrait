Portrait::Application.routes.draw do
  resources :sites
  resources :users

  root to: 'home#index'
end
