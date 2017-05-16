class OrdersController < ApplicationController
  before_filter :set_order, only: [:destroy, :print, :pay, :cancel, :open]
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def index
    @orders = Order.not_empty
    if params[:type].present?
      @orders = @orders.send(params[:type])
    end
    @orders = @orders.search(params[:keyword]).page(params[:page]).per(10)
  end

  def destroy
    @order.delete

    flash[:success] = "Pedido removido"
    redirect_to orders_path
  end

  def print
    render layout: nil
  end

  def pay
    @order.pay!

    redirect_to orders_path, notice: "Pagamento confirmado."
  end

  def cancel
    @order.cancel!

    redirect_to orders_path, notice: "Pedido cancelado."
  end

  def open
    @order.open!

    redirect_to orders_path, notice: "Pedido aberto."
  end

private

  def set_order
    @order = Order.find(params[:id])
  end
end
