ActionController::Routing::Routes.draw do |map|
    map.resources :employees 
    map.resources :designations
    map.resources :departments
    map.resources :hierarchies
  
end
