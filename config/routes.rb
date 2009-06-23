ActionController::Routing::Routes.draw do |map|
  map.resources :sites, :collection=>{:api=>:post}
  map.resources :users
  
  map.api  '', :controller=>'sites', :action=>'api',   :conditions => { :method=>:post }
  map.home '', :controller=>'home',  :action=>'index', :conditons  => { :method=>:get  }
end
