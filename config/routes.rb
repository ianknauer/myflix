Myflix::Application.routes.draw do
  root to: 'pages#front'
  
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get 'register', to: "users#new"
  get 'register/:token', to: "users#new_with_token", as: 'register_with_token'
  get '/sign_in', to: 'sessions#new'
  get '/sign_out', to: 'sessions#destroy'
  post 'update_queue', to: 'queue_items#update_queue' 
  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  get 'expired_token', to: 'pages#expired_token'
  resources :invitations, only: [:new, :create]
  
  resources :password_resets, only: [:show, :create]
  
  get 'my_queue', to: 'queue_items#index'
  resources :forgot_passwords, only: [:create]
  
  resources :videos, only: [:show] do
    collection do
      post :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end
  resources :relationships, only: [:create, :destroy]
  resources :categories
  resources :users, only: [:create, :show]
  get 'people', to: 'relationships#index'
  resources :sessions, only: [:create]
  resources :queue_items, only: [:create, :destroy]
  
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
