ActionController::Routing::Routes.draw do |map|
  map.resources :achievements, :only => [:index]

  map.resources :items

  map.resources :loots, :except => [:show], :member => { :price => :get }

  map.resources :live_raids, :as => 'attendance', :controller => 'attendance/raids', :except => [:edit], :member => { :start => :get, :stop => :get, :post => :get } do |lr|
    lr.resources :live_loots, :as => 'loots', :controller => 'attendance/loots', :only => [:update, :destroy]
    lr.resources :live_attendees, :as => 'attendees', :controller => 'attendance/attendees', :only => [:update, :destroy]
  end

  map.resources :members do |member|
    member.resources :achievements, :controller => 'members/achievements', :only   => [:index]
    member.resources :loots,        :controller => 'members/loots',        :only   => [:index]
    member.resources :punishments,  :controller => 'members/punishments',  :except => [:show]
    member.resources :raids,        :controller => 'members/raids',        :only   => [:index]
    member.resources :wishlists,    :controller => 'members/wishlists',    :except => [:show]
  end

  map.resources :raids

  map.resource :search, :only => [:show]

  map.resources :wishlists, :only => [:index]

  map.resource :user_session, :only => [:create, :destroy]
  map.login  'login',  :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy', :method => 'delete'

  map.root :controller => 'index', :action => 'index'
end
