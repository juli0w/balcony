class OrdersController < ApplicationController
  before_filter :set_order, only: [:boleto, :setcc, :check_order, :destroy, :print, :pay, :pay_with_cash, :cancel, :open, :quote]
  before_action :authenticate_user!
  before_action :authenticate_admin!, only: [:setcc, :boleto]
  # before_action :authenticate_vendedor!

  def index
    if current_user.admin?
      @orders = Order.not_empty
    else
      @orders = current_user.orders.not_empty.opened_and_quote
    end

    if params[:type].present?
      @orders = @orders.send(params[:type])
    end
    @orders = @orders.search(params[:keyword]).page(params[:page]).per(10).order("orders.submited_at DESC, orders.id DESC")
  end

  def edit
    session[:client] = Order.find(params[:id]).client_id
    session[:order_id] = params[:id]
    redirect_to root_path
  end

  def destroy
    @order.delete

    flash[:success] = "Pedido removido"
    redirect_to orders_path
  end

  def print
    render layout: nil
  end

  def boleto
    @order.boleto = params[:value]

    if params[:value] == "true"
      @order.cc_value = 0
    end
    
    @order.save
  end

  def check_order
    @order.coupon = params[:value]
    @order.save
  end

  def setcc
    ccvalue = params.require(:order).permit(:cc_value)[:cc_value]
    @order.update(cc_value: ccvalue)

    flash[:success] = "Pedido alterado"
    redirect_to orders_path
  end

  def pay
    @order.pay!

    redirect_to orders_path(type: params[:type]), notice: "Pagamento confirmado."
  end

  def pay_with_cash
    @order.pay_with_cash!

    redirect_to orders_path(type: params[:type]), notice: "Pagamento confirmado."
  end

  def quote
    @order.quote!

    redirect_to orders_path(type: params[:type]), notice: "Orçamento confirmado."
  end

  def cancel
    @order.cancel!

    redirect_to orders_path(type: params[:type]), notice: "Pedido cancelado."
  end

  def open
    @order.open!

    redirect_to orders_path(type: params[:type]), notice: "Pedido aberto."
  end

private

  def set_order
    @order = Order.find(params[:id])
  end
end
