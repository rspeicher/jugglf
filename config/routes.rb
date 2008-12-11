ActionController::Routing::Routes.draw do |map|
  map.resources :members, :raids

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
