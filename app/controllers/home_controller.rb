class HomeController < ApplicationController
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
