ActionController::Routing::Routes.draw do |map|
  map.resources :items, :raids
  map.resources :loots, :member => { :price => :get }
  
  map.connect 'members/:id/t.:tab', :controller => 'members', :action => 'show'
  map.resources :members, :has_many => [ :punishments, :wishlists ]
  
  map.resources :achievements, :only => [:index]
  map.resources :wishlists, :only => [:index]
  
  map.resources :live_raids, :as => 'attendance', :controller => 'attendance/raids' do |lr|
    lr.resources :live_loots, :as => 'loots', :controller => 'attendance/loots', :only => [:edit, :update, :destroy]
  end
  
  # map.resources :live_raids, :as => 'attendance', :controller => 'attendance', :member => { :stop => :get, :resume => :get, :insert => :get } do |live|
  #   live.resources :live_attendees, :as => 'attendees', :controller => 'attendance_attendees', :only => [:update]
  #   live.resources :live_loots,     :as => 'loots',     :controller => 'attendance_loots',     :only => [:edit, :update, :destroy]
  # end
  
  map.resource :user_session, :only => [:new, :create, :destroy]

  map.connect 'search/:context.:format',        :controller => 'search', :action => 'index'
  map.connect 'search/:context/:query',         :controller => 'search', :action => 'index'
  map.connect 'search/:context/:query.:format', :controller => 'search', :action => 'index'
  
  map.connect '/login', :controller => 'user_sessions', :action => 'new'
  map.connect '/logout', :controller => 'user_sessions', :action => 'destroy'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.root :controller => 'index', :action => 'index'
end
