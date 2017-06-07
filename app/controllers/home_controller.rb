class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_caixa!, only: [:caixa, :caixa_update]

  def index
    @items = Item.order(:name).search(params[:key].try(:upcase)).first(50)
  end

  def caixa
    @orders = Order.not_empty.opened
  end

  def caixa_update
    @orders = Order.not_empty.opened
    render partial: "caixa"
  end
end
