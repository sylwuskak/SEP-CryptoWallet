Rails.application.routes.draw do
  get 'home/index'

  resources :wallets, only: [:create, :new, :show, :index, :destroy, :update] do
    
  end

  devise_for :users

  devise_scope :user do
    authenticated :user do
      root to: 'wallets#index', as: :unauthenticated_root
    end

    unauthenticated :user do
      root to: 'home#index', as: :authenticated_root
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
