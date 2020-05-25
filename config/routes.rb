Rails.application.routes.draw do
  root 'static_pages#home'


  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :users, only: [:new, :create, :show, :update]

  get    '/users/:id/friends', to: 'users#friends'
  get    '/profile',   to: 'users#profile'
  get    '/profile/edit',   to: 'users#edit_profile'
  get    '/invite',   to: 'users#invite'
  post   '/create_invite', to: 'users#create_invite'

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  resources :topics,    only: [:new, :create, :show, :edit, :update, :index]
  resources :stories,   only: [:new, :create, :show, :edit, :update, :index]
  resources :comments,  only: [:create, :edit]

  resources :friendships, path: "friends",    only: [:create, :index, :confirm] do
    member do
      post :confirm, to: 'friendships#confirm'
    end
  end

end
