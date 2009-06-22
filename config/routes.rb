ActionController::Routing::Routes.draw do |map|
  map.resources :sites, :collection=>{:api=>:post}
  map.root :controller=>'sites', :action=>'api', :method=>:post
end
