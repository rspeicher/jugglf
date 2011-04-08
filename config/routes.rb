JuggLF::Application.routes.draw do
  # resources :achievements, :only => [:index]

  resources :items

  resources :loots, :except => [:show] do
    get :price, :on => :member
  end

  scope :module => "attendance" do
    resources :live_raids, :path => "attendance", :controller => "raids", :except => [:edit] do
      get :start, :on => :member
      get :stop,  :on => :member
      get :post,  :on => :member

      resources :live_loots,     :path => "loots",     :controller => "loots",     :only => [ :update, :destroy]
      resources :live_attendees, :path => "attendees", :controller => "attendees", :only => [ :update, :destroy]
    end
  end

  resources :members do
    # resources :achievements, :controller => 'members/achievements', :only   => [:index]
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
