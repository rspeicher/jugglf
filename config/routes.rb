ActionController::Routing::Routes.draw do |map|
  map.resources :items, :raids
  
  map.resources :members, :has_many => [ :punishments ]
  
  map.resource :user_session
  # map.resource :account, :controller => 'users'
  # map.resources :users

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.root :controller => "members"
  #map.root :controller => "user_sessions", :action => "new"
end
