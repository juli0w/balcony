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
    @order = current_cart
    @order.open!

    reset_session

    redirect_to root_path
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
