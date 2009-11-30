ActionController::Routing::Routes.draw do |map|
    map.resources :employees 
    map.resources :roles
    map.resources :departments
end
