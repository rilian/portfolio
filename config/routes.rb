Portfolio::Application.routes.draw do
  #devise_for :users

  root :to => 'home#index'

  resources :categories
  resources :posts
  resources :home, :only => [:index] do
    get :about, :on => :collection
    get :contacts, :on => :collection
  end
end
