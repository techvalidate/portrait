Portrait::Application.routes.draw do
  get 'password_resets/new'

  resources :sites do
    post 'api', on: :collection
  end

  resources :users
  resources :sessions
  resources :password_resets

  get 'login'=>'sessions#new'
  post 'login'=>'sessions#create'
  delete 'logout'=>'sessions#destroy'

  get '/forgot_password'=>'password_resets#new'
  post '/reset_password'=>'password_resets#create'

  post '/'=>'sites#api',  as: 'api'
  get  '/'=>'home#index', as: 'root'

end
