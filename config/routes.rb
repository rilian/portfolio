Portfolio::Application.routes.draw do
  if Rails.env.production?
    devise_for :users, :controllers => { :registrations => "registrations" }
  else
    devise_for :users
  end

  authenticated :user do
    root :to => 'home#index'
  end

  match '/contacts' => 'home#contacts'

  root :to => 'home#index'

  resources :categories
  resources :images
end
