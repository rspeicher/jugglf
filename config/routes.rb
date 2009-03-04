ActionController::Routing::Routes.draw do |map|
  map.connect 'wishlists/globalview', :controller => 'wishlists', :action => 'globalview'
  
  map.resources :items, :loots, :raids, :wishlists
  map.resources :members, :has_many => [ :punishments ]
  
  map.resource :user_session

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.root :controller => 'index', :action => 'index'
end
