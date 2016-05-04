Portrait::Application.routes.draw do
  resources :sites do
    post 'api', on: :collection
  end

  resources :users
  resources :password_resets, except: [:index, :show, :delete]

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  post '/'=>'sites#api',  as: 'api'
  get  '/'=>'home#index', as: 'root'
end
