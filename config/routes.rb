Rails.application.routes.draw do
  root 'forums#index'

  resources :comments
  resources :topics
  resources :categories
  devise_for :users, controllers: { sessions: "devise_ex/sessions",
                                    registrations: "devise_ex/registrations" }

  resource :forums do
    get 'index'
    get 'admin'
    get 'home'
    post 'search'
    get 'search'
    get 'page/:page', :action => :index, :on => :collection
  end

  namespace :admin do
    resources :comments, :only => [:index, :show, :edit, :update, :destroy]
    resources :categories do
      get 'page/:page', :action => :index, :on => :collection
    end
    resources :topics do
      get 'page/:page', :action => :index, :on => :collection
    end
    resources :users, :only => [:index, :show, :edit]
    post 'users/:id' => 'users#update'
    patch 'users/:id' => 'users#update'

  end

end
