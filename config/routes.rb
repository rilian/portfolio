Portfolio::Application.routes.draw do
  if Rails.env.production?
    devise_for :users, controllers: { registrations: 'registrations' }
  else
    devise_for :users
  end

  authenticated :user do
    root to: 'home#index'
  end

  match '/rss' => 'home#rss', as: :rss_feed, defaults: { format: 'rss' }

  root to: 'home#index'

  resources :albums
  resources :projects
  resources :images
  resources :photos, only: :destroy
  resources :settings
end
