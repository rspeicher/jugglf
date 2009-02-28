ActionController::Routing::Routes.draw do |map|
  map.resources :items, :loots, :raids
  map.resources :members, :has_many => [ :punishments ]
  
  map.resource :user_session

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.root :controller => "members"
end
