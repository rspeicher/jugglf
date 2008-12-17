ActionController::Routing::Routes.draw do |map|
  map.resources :items, :members, :raids

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.root :controller => "members"
end
