ActionController::Routing::Routes.draw do |map|
  map.resources :items, :loots, :raids
  
  map.connect 'members/:id/t.:tab', :controller => 'members', :action => 'show'
  map.resources :members, :has_many => [ :punishments, :wishlists ]
  
  map.resources :wishlists, :only => [:index]
  
  map.resource :user_session

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.root :controller => 'index', :action => 'index'
end
