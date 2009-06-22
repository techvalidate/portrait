ActionController::Routing::Routes.draw do |map|
  map.resources :sites
  map.root :controller=>'sites', :action=>'create', :method=>:post
end
