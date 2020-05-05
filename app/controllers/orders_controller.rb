class OrdersController < ApplicationController
  before_filter :set_order, only: [:pending, :boleto, :setcash, :setboleto, :setcc, :check_order, :destroy, :print, :pay, :pay_with_cash, :cancel, :open, :quote]
  before_action :authenticate_user!
  before_action :authenticate_admin!, only: [:edit]
  # before_action :authenticate_caixa!, only: [:setcc, :setcash, :boleto]
  # before_action :authenticate_vendedor!

  def index
    if current_user.admin?
      @orders = Order.not_empty
    else
      user = current_user.stock.user
      @orders = user.orders.not_empty.opened_and_quote
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
    @order.update(printed: true)
    
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
    @order.update(cc_value: ccvalue, boleto_value: 0)

    flash[:success] = "Pedido alterado"

    respond_to do |format|
      format.js
    end
  end

  def setboleto
    boletovalue = params.require(:order).permit(:boleto_value)[:boleto_value]
    @order.update(boleto_value: boletovalue, cc_value: 0)

    flash[:success] = "Pedido alterado"

    respond_to do |format|
      format.js
    end
  end

  def setcash
    discount = params.require(:order).permit(:discount)[:discount]
    shipping = params.require(:order).permit(:shipping)[:shipping]
    @order.update(discount: discount, shipping: shipping)

    flash[:success] = "Pedido alterado"
    
    render :setcash
    #redirect_to orders_path
  end

  def pay
    @order.pay!

    redirect_to orders_path(type: params[:type]), notice: "Pagamento confirmado."
  end

  def pending
    @order.pending!

    redirect_to orders_path(type: params[:type]), notice: "Pedido em carteira."
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
