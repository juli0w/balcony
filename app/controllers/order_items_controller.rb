class OrderItemsController < ApplicationController
  def create
    @order = current_cart
    @order_item = @order.add_item(order_item_params)
    @order.save
    session[:order_id] = @order.id

    redirect_to root_path(key: params[:key])
  end

  def destroy
    @order = current_cart
    @order.order_items.find(params[:id]).delete

    redirect_to root_path(key: params[:key])
  end

  def clean
    reset_session

    redirect_to root_path(key: params[:key])
  end

  def finish
    if current_cart.empty?
      notice = "Você não adicionou itens ao pedido"
    else
      @order = current_cart
      @order.open!

      if user_signed_in?
        @order.update(user: current_user)
      end

      notice = "Pedido realizado com sucesso. Por favor dirija-se ao caixa!"
      reset_session
    end

    redirect_to root_path, notice: notice
  end

  def pay
    @order = Order.find(params[:id])
    @order.pay!

    redirect_to caixa_path
  end

  def cancel
    @order = Order.find(params[:id])
    @order.cancel!

    redirect_to caixa_path
  end

private

  def order_item_params
    params.permit(:quantity, :item_id)
  end
end
