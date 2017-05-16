Rails.application.routes.draw do
  devise_for :users, :path => 'u'
  get "import", to: "efator#index"
  post "import", to: "efator#import"
  post "reset", to: "efator#reset"
  get "clean", to: "order_items#clean"
  post "finish_order", to: "order_items#finish"
  post "shipping_order", to: "order_items#shipping"
  get "clients", to: "order_items#clients"
  get "caixa", to: "home#caixa"
  post "pay", to: "order_items#pay"
  post "cancel", to: "order_items#cancel"
  get "caixa_update", to: "home#caixa_update"

  resources :items
  resources :orders do
    member do
      post :pay
      post :cancel
      post :open
      post :print
    end
  end
  resources :users do
    member do
      post :become
    end
  end

  resources :order_items, only: [:create, :destroy, :update]

  root to: "home#index"
end
