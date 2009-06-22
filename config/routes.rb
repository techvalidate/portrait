ActionController::Routing::Routes.draw do |map|
  map.resources :sites, :collection=>{:api=>:post}
  map.resources :users
  
  map.root :controller=>'sites', :action=>'api', :method=>:post
end
