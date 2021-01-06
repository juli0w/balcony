Rails.application.routes.draw do
  devise_for :users, :path => 'u'

  authenticate :user, ->(u) { u.admin? } do
    mount ExceptionTrack::Engine => "/errors"
  end

  # formulas
  get "import_2", to: "formulas#index", as: "formulas"
  post "import_2", to: "formulas#import"

  get "order_check/:id", to: "orders#check_order"

  get "pigmentos", to: "formulas#pigmentos", as: "pigmentos_formulas"
  get "acabamentos", to: "formulas#acabamentos", as: "acabamentos_formulas"
  get "integracao", to: "formulas#integracao", as: "integracao_formulas"
  get "Fórmulas", to: "formulas#formulas", as: "list_formulas"

  get "tintas/sw", to: "tintas#sw", as: "sw"
  get "tintas/wanda", to: "tintas#wanda", as: "wanda"

  # get  "change_dye_item", to: "formulas#change_dye_item", as: "change_dye_item"
  post "change_dye_item/:id", to: "formulas#change_dye_item", as: "change_dye_item"
  get "search_dye_item/:id", to: "formulas#search_dye_item", as: 'search_dye_item'

  post "change_base_item/:id", to: "formulas#change_base_item", as: "change_base_item"
  get "search_base_item/:id", to: "formulas#search_base_item", as: 'search_base_item'

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

  post "quote", to: "order_items#quote"
  post "cancel", to: "order_items#cancel"
  get "caixa_update", to: "home#caixa_update"

  get  "pontos", to: "home#pontos"
  post "pontos", to: "home#pontos"

  get  "tintas", to: "home#tintas"

  # reports

  get "reports/abc", to: "reports#abc", as: "abc_report"
  get "reports/dashboard", to: "reports#dashboard", as: "dashboard_report"
  get "reports/sales", to: "reports#sales", as: "sales_report"
  get "reports/sales_by_day", to: "reports#sales_by_day", as: "sales_by_day_report"
  get "reports/items", to: "reports#items", as: "items_report"
  get "reports/by_client", to: "reports#by_client", as: "by_client_report"
  get "reports/by_client_print", to: "reports#by_client_print", as: "by_client_print_report"

  #

  resources :close_days
  get "checkout", to: "outputs#close_day", as: "checkout"

  resources :outputs
  
  resources :stocks
  resources :stock_changes
  resources :stock_transfers

  resources :listings
  resources :items do
    member do
      post :change_location
      post :check
    end
    collection do
      get :print
    end
  end
  
  resources :sections
  resources :orders do
    member do
      post :edit_obs
      put :setcc
      put :setboleto
      put :setcash
      post :pay
      post :cancel
      post :open
      post :quote
      post :pending
      post :pay_with_cash
      post :print
      get  :print
      post :boleto
      post :gerar_boleto
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

  resources :order_items,  only: [:create, :destroy, :update] do
    member do
      post :add_by_value
    end
  end

  resources :order_tintas, only: [:create, :destroy, :update]

  root to: "home#index"
end
