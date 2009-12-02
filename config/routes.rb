ActionController::Routing::Routes.draw do |map|
    map.resources :employees 
    map.resources :designations
    map.resources :departments
end
