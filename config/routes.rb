Portrait::Application.routes.draw do
  devise_for :users
  resources :users

  resources :sites do
    post 'api', :on=>:collection
  end

  post '/'=>'sites#api',  as: 'api'
  get  '/'=>'home#index', as: 'root'
end
