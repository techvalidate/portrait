Portrait::Application.routes.draw do
  resources :sites
  resources :users
  resources :site_batches, only: %i(create show)

  root to: 'home#index'
end
