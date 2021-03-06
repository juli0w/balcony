class OrdersController < ApplicationController
  before_filter :set_order,
    only: [:edit_obs,
           :pending,
           :boleto,
           :setcash,
           :setboleto,
           :gerar_boleto,
           :setcc,
           :setpix,
           :digital,
           :check_order, :destroy, :print, :pay, :pay_with_cash, :cancel, :open, :quote]
  
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

    # @orders = @orders.where('created_at > ?', 4.days.ago) unless current_user.super?

    if params[:type].present?
      @orders = @orders.send(params[:type])
    end

    if params[:digital].present?
      @orders = @orders.digital
    end

    if params[:date].present?
      date = params[:date].to_date
      @orders = @orders.where('created_at > ? and created_at < ?',
                                date.beginning_of_day,
                                date.end_of_day)
    end

    if params[:seller].present?
      @orders = @orders.where(seller: params[:seller])
    end

    if params[:stock].present?
      stock = Stock.find(params[:stock])
      @orders = @orders.where(user_id: stock.user_id)
    end

    @orders = @orders.search(params[:keyword]).page(params[:page]).per(10).order("orders.submited_at DESC, orders.id DESC")
  end

  def edit_obs
    @order.update(obs: params[:obs])

    redirect_to "/orders?type=#{params[:type]}&keyword=#{params[:keyword]}##{@order.id}"
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

  def digital
    @order.update(digital: !@order.digital)
    @removeClass = @order.digital ? 'blue' : 'green'
    @addClass = !@order.digital ? 'blue' : 'green'
  end

  def boleto
    @order.boleto = params[:value]
    @order.boleto_value = @order.total

    if params[:value] == "true"
      @order.cc_value = 0
    end
    
    @order.save
  end

  def gerar_boleto
    @order.boleto_gerado = true

    @order.save

    redirect_to :back
  end

  def check_order
    @order.coupon = params[:value]
    @order.save
  end

  def setcc
    wparams = params.require(:order).permit(:cc_value, :credito)

    ccvalue = wparams[:cc_value]
    credito = wparams[:credito]

    @order.update(cc_value: ccvalue, boleto_value: 0, credito: credito)

    flash[:success] = "Pedido alterado"

    respond_to do |format|
      format.js
    end
  end


  def setpix
    wparams = params.require(:order).permit(:total_pix)

    total_pix = wparams[:total_pix]

    @order.update(total_pix: total_pix)

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
