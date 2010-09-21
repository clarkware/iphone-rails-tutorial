# START:routes
Saveup::Application.routes.draw do |map|
  
  resources :goals do
    resources :credits
  end
# END:routes

  root :to => "goals#index"

  map.resources :sessions, :users

  match 'login'  => 'sessions#new',     :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'join'   => 'users#new',        :as => :join
  match 'about'  => 'info#index',       :as => :about

# START:routes

end
# END:routes
