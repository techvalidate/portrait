Portrait::Application.routes.draw do
  resources :sites do
    post 'api', :on=>:collection
  end
  
  resources :users
  
  post '/'=>'sites#api',  :as=>'api'
  root :to=>'home#index'
  
end
