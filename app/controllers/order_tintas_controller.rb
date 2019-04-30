class OrderTintasController < ApplicationController
  # before_filter :authenticate_vendedor!

  def create
    @order = current_cart
    @order_tinta = @order.add_tinta(order_params)
    @order.save
    session[:order_id] = @order.id

    respond_to do |format|
      format.js { render 'warn' }
    end
  end

  def update
    @order = current_cart
    @order_tinta = current_cart.order_tintas.find(params[:id])
    @order_tinta.update(order_tinta_params)

    session[:order_id] = @order.id

    respond_to do |format|
      format.js { render 'warn' }
    end
  end

  def destroy
    @order = current_cart
    @order.order_tintas.find(params[:id]).delete

    redirect_to root_path(key: params[:key])
  end

private

  def order_params
    params.permit(:quantity, :tinta_id, :tinta_embalagem_id)
  end

  def order_tinta_params
    params.require(:order_tinta).permit(:quantity, :tinta_id, :tinta_embalagem_id)
  end
end
