Portfolio::Application.routes.draw do
  #devise_for :users

  root :to => 'home#index'
  match '/about' => 'home#about'
  match '/contacts' => 'home#contacts'

  resources :categories, :only => [:show]
  resources :posts
  resources :images, :only => [:create, :destroy]
end
