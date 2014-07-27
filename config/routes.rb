Rails.application.routes.draw do
  if Rails.env.production?
    devise_for :users, controllers: { registrations: 'registrations' }
  else
    devise_for :users
  end

  get '/rss' => 'home#rss', as: :rss_feed, defaults: { format: 'rss' }
  get '/contacts' => 'home#contacts', as: :contacts

  resources :albums
  resources :projects
  resources :images
  resources :photos, only: :destroy
  resources :settings

  root to: 'home#index'
end
