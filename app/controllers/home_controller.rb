class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:caixa, :caixa_update]
  before_action :authenticate_caixa!, only: [:caixa, :caixa_update]

  def index
    @items = Item.search(params[:key]).last(20)
  end

  def caixa
    @orders = Order.open
  end

  def caixa_update
    @orders = Order.open
    render partial: "caixa"
  end
end
