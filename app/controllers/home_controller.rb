class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_caixa!, only: [:caixa, :caixa_update]

  def index
    @items = Item.order('image desc').order(:name).search(params[:key].upcase).first(20)
  end

  def caixa
    @orders = Order.open
  end

  def caixa_update
    @orders = Order.open
    render partial: "caixa"
  end
end
