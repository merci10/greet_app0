Rails.application.routes.draw do

  root 'static_pages#home'
  get '/home', to: 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  post '/like/:note_id', to: 'likes#create', as: 'like'
  delete '/unlike/:note_id', to: 'likes#destroy', as: 'unlike'
  resources :users do
    member do
      get :following, :followers
      get :like_notes
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :notes, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
end
