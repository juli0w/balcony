class StockTransfersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def index
    @stock_transfers = StockTransfer.last(100)

    respond_to do |format|
      format.html
    end
  end

  def new
    if current_cart.empty?
      notice = "Você não adicionou itens"
      redirect_to root_path, notice: notice
    else
      @stock_transfer = StockTransfer.new
    end
  end

  def create
    @stock_transfer = StockTransfer.new(stock_transfer_params)
    @stock_transfer.user = current_user

    if @stock_transfer.save
      @stock_transfer.push! current_cart
      reset_session
      redirect_to root_path, notice: "Itens transferidos com sucesso"
    else
      flash.now[:alert] = "Por favor verifique os campos."
      render :new
    end
  end

  def stock_transfer_params
    params.require(:stock_transfer).permit(:from_id, :to_id)
  end
end
