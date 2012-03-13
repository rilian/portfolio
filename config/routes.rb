Portfolio::Application.routes.draw do
  #devise_for :users

  root :to => 'posts#index'
  match '/about' => 'home#about'
  match '/contacts' => 'home#contacts'

  resources :categories, :only => [:show]
  resources :posts, :except => [:index]
  resources :images, :only => [:destroy] do
    post :cache_uploader, :on => :collection
    put :cache_uploader, :on => :collection
  end
end
