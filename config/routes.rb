ActionController::Routing::Routes.draw do |map|
  map.resources :items, :loots, :raids
  
  map.connect 'members/:id/t.:tab', :controller => 'members', :action => 'show'
  map.resources :members, :has_many => [ :punishments, :wishlists ]
  
  map.resources :achievements, :only => [:index]
  map.resources :wishlists, :only => [:index]
  
  map.resource :user_session

  map.connect 'search/:context.:format',        :controller => 'search', :action => 'index'
  map.connect 'search/:context/:query',         :controller => 'search', :action => 'index'
  map.connect 'search/:context/:query.:format', :controller => 'search', :action => 'index'
  
  map.connect '/login', :controller => 'user_sessions', :action => 'new'
  map.connect '/logout', :controller => 'user_sessions', :action => 'destroy'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.root :controller => 'index', :action => 'index'
end
