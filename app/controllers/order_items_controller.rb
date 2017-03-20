class OrderItemsController < ApplicationController
  def create
    @order = current_cart
    @order_item = @order.add_item(order_params)
    @order.save
    session[:order_id] = @order.id

    respond_to do |format|
      format.html { redirect_to root_path(key: params[:key]) }
      format.js { render 'item/create' }
    end
  end

  def update
    @order = current_cart
    @order_item = current_cart.order_items.find(params[:id])
    @order_item.update(order_item_params)

    session[:order_id] = @order.id

    respond_to do |format|
      format.html { redirect_to root_path(key: params[:key]) }
      format.js { render 'item/create' }
    end
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

  def shipping
    if current_cart.empty?
      notice = "Você não adicionou itens ao pedido"
      redirect_to root_path, notice: notice
    else
      @order = current_cart
      @order.open!
      @client = @order.build_client

      if user_signed_in?
        @order.update(user: current_user)
      end

      render "item/shipping"
    end
  end

  def finish
    @order = current_cart
    @client = @order.create_client(client_params)

    notice = "Pedido realizado com sucesso!"

    reset_session
    redirect_to root_path, notice: notice
  end

  def pay
    @order = Order.find(params[:id])
    @order.pay!

    redirect_to caixa_path, notice: "Pagamento confirmado. Despachar produtos."
  end

  def cancel
    @order = Order.find(params[:id])
    @order.cancel!

    redirect_to caixa_path, notice: "Pedido cancelado."
  end

private

  def client_params
    params.require(:client).permit(:name, :address, :city, :uf,
                                   :cpf, :phone, :cep, :birthday, :line)
  end

  def order_params
    params.permit(:quantity, :item_id)
  end

  def order_item_params
    params.require(:order_item).permit(:quantity, :item_id)
  end
end
