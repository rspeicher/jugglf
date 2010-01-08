ActionController::Routing::Routes.draw do |map|
  map.resources :achievements, :only => [:index]
  map.resources :items, :raids
  map.resources :loots, :member => { :price => :get }
  map.resources :members do |member|
    # member.resources :achievements, :controller => 'members/achievements', :only => [:index]
    member.resources :loots,     :controller => 'members/loots',     :only   => [:index]
    # member.resources :punishments
    member.resources :raids,     :controller => 'members/raids',     :only   => [:index]
    member.resources :wishlists, :controller => 'members/wishlists', :except => [:show]
  end
  map.resources :live_raids, :as => 'attendance', :controller => 'attendance/raids', :except => [:edit], :member => { :start => :get, :stop => :get, :post => :get } do |lr|
    lr.resources :live_loots, :as => 'loots', :controller => 'attendance/loots', :only => [:update, :destroy]
    lr.resources :live_attendees, :as => 'attendeees', :controller => 'attendance/attendees', :only => [:update, :destroy]
  end
  map.resources :wishlists, :only => [:index]
  
  map.resource :user_session, :only => [:new, :create, :destroy]

  map.connect 'search/:context.:format',        :controller => 'search', :action => 'index'
  map.connect 'search/:context/:query',         :controller => 'search', :action => 'index'
  map.connect 'search/:context/:query.:format', :controller => 'search', :action => 'index'
  
  map.login  'login',  :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy', :method => :delete
  
  map.root :controller => 'index', :action => 'index'
end
