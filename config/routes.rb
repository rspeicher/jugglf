JuggLF::Application.routes.draw do |map|
  resources :achievements, :only => [:index]

  resources :items

  resources :loots, :except => [:show] do
    get :price, :on => :member
  end

  # map.resources :live_raids, :as => 'attendance', :controller => 'attendance/raids', :except => [:edit], :member => { :start => :get, :stop => :get, :post => :get } do |lr|
  #   lr.resources :live_loots, :as => 'loots', :controller => 'attendance/loots', :only => [:update, :destroy]
  #   lr.resources :live_attendees, :as => 'attendees', :controller => 'attendance/attendees', :only => [:update, :destroy]
  # end

  resources :members do
    resources :achievements, :controller => 'members/achievements', :only   => [:index]
    resources :loots,        :controller => 'members/loots',        :only   => [:index]
    resources :punishments,  :controller => 'members/punishments',  :except => [:show]
    resources :raids,        :controller => 'members/raids',        :only   => [:index]
    resources :wishlists,    :controller => 'members/wishlists',    :except => [:show]
  end

  resources :raids

  resource :search, :only => [:show]

  resources :wishlists, :only => [:index]

  resource :user_session, :only => [:create, :destroy]

  # login  'login',  :controller => 'user_sessions', :action => 'new'
  match "/login" => "user_sessions#new"

  # logout 'logout', :controller => 'user_sessions', :action => 'destroy', :method => 'delete'
  match "/logout" => "user_sessions#destroy", :method => :delete

  root :to => "index#index"
end
