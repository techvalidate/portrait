Portrait::Application.routes.draw do
  devise_for :users

  resources :sites do
    post 'api', :on=>:collection
  end
  
  resources :users
  resources :customers

  post '/'=>'sites#api',  as: 'api'
  get  '/'=>'home#index', as: 'root'
end
