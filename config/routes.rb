Rails.application.routes.draw do
  get "import", to: "efator#index"
  post "import", to: "efator#import"
  get "clean", to: "order_items#clean"
  post "finish_order", to: "order_items#finish"
  get "caixa", to: "home#caixa"
  post "pay", to: "order_items#pay"
  post "cancel", to: "order_items#cancel"
  get "caixa_update", to: "home#caixa_update"

  resources :order_items, only: [:create, :destroy]

  root to: "home#index"
end
