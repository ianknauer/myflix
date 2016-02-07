Myflix::Application.routes.draw do
  root to: 'pages#front' #starting route

  get 'ui(/:action)', controller: 'ui' #only accessible when in development environment
  get '/home', to: 'videos#index' #home loads main videos
  get 'register', to: "users#new" #shorterner for users/new
  get 'register/:token', to: "users#new_with_token", as: 'register_with_token' #route allows token from invite email to be passed in as a parameter
  get '/sign_in', to: 'sessions#new' #sesions info
  get '/sign_out', to: 'sessions#destroy' #session info
  post 'update_queue', to: 'queue_items#update_queue' #video queue
  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  get 'expired_token', to: 'pages#expired_token'
  resources :invitations, only: [:new, :create] #users can invite others to join, new users automatically follow those who invited them

  resources :password_resets, only: [:show, :create]

  namespace :admin do #only allow admins to add videos + access payment info of others
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end

  get 'my_queue', to: 'queue_items#index'
  resources :forgot_passwords, only: [:create]

  resources :videos, only: [:show] do
    collection do
      post :search, to: "videos#search" #allows for video search
    end
    resources :reviews, only: [:create]
  end
  resources :relationships, only: [:create, :destroy] #between user + invitee
  resources :categories #videos belong to categories
  resources :users, only: [:create, :show]
  get 'people', to: 'relationships#index'
  resources :sessions, only: [:create]
  resources :queue_items, only: [:create, :destroy] #allowed to see what's next for them on the queue

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq' #email is processed async, this is a web interface to see what sidekiq is up to.
  mount StripeEvent::Engine => '/stripe_events' #allows rails to read incoming stripe events (like payments)
end
