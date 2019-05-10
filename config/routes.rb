Rails.application.routes.draw do
  devise_for :users, :path => 'u'

  # formulas
  get "import_2", to: "formulas#index", as: "formulas"
  post "import_2", to: "formulas#import"

  get "pigmentos", to: "formulas#pigmentos", as: "pigmentos_formulas"
  get "acabamentos", to: "formulas#acabamentos", as: "acabamentos_formulas"
  get "integracao", to: "formulas#integracao", as: "integracao_formulas"
  get "Fórmulas", to: "formulas#formulas", as: "list_formulas"

  # efator
  get "import", to: "efator#index"
  post "import", to: "efator#import"
  post "reset", to: "efator#reset"

  # resicolor
  get "resicolor", to: "resicolor#index"
  post "resicolor", to: "resicolor#import"
  get "resicolor/integrate", to: "resicolor#integrate"
  get "resicolor/rproducts", to: "resicolor#rproducts"
  get "resicolor/rproducts/:id/search", to: "resicolor#search", as: 'rproduct_search'
  post "resicolor/rproduct/:id", to: "resicolor#change", as: :resicolor_rproduct
  get "resicolor/rbases", to: "resicolor#rbases"
  patch "resicolor/rbase_update", to: "resicolor#rbase_update"
  get "resicolor/rformulas", to: "resicolor#rformulas"
  post "resicolor/reset", to: "resicolor#reset"

  get "clean", to: "order_items#clean"
  post "finish_order", to: "order_items#finish"
  post "shipping_order", to: "order_items#shipping"
  get "get_clients", to: "order_items#clients"
  get "caixa", to: "home#caixa"
  post "pay", to: "order_items#pay"
  post "cancel", to: "order_items#cancel"
  get "caixa_update", to: "home#caixa_update"

  get  "pontos", to: "home#pontos"
  post "pontos", to: "home#pontos"

  get  "tintas", to: "home#tintas"

  # reports

  get "reports/dashboard", to: "reports#dashboard", as: "dashboard_report"
  get "reports/sales", to: "reports#sales", as: "sales_report"
  get "reports/items", to: "reports#items", as: "items_report"
  get "reports/by_client", to: "reports#by_client", as: "by_client_report"
  get "reports/by_client_print", to: "reports#by_client_print", as: "by_client_print_report"

  #

  resources :listings
  resources :items do
    collection do
      get :print
    end
  end
  resources :sections
  resources :orders do
    member do
      post :pay
      post :cancel
      post :open
      post :print
      get  :print
    end
  end
  resources :clients do
    member do
      get :select
      get :clear
    end
  end
  get :profile, controller: :clients
  post :profile, controller: :clients, action: :update_profile
  resources :users do
    member do
      post :become
    end
  end

  resources :order_items,  only: [:create, :destroy, :update]
  resources :order_tintas, only: [:create, :destroy, :update]

  root to: "home#index"
end
