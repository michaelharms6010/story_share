Rails.application.routes.draw do
  root 'static_pages#home'

  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get    '/invite',   to: 'users#invite'

  resources :users, only: [:new, :create, :update, :show, :edit]

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  resources :topics,    only: [:new, :create, :destroy, :show, :edit, :update, :index]
  resources :stories,   only: [:new, :create, :destroy, :show, :edit, :update, :index]

  resources :friendships, path: "friends",    only: [:show, :update, :create, :index] do
    member do
      post :confirm, to: 'friendships#confirm'
    end
  end

end
