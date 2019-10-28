class StocksController < ApplicationController
  before_filter :set_stock, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def index
    @stocks = Stock.all
  end

  def new
    @stock = Stock.new
  end

  def create
    @stock = Stock.new(stock_params)

    if @stock.save
      redirect_to stocks_path, notice: "Estoque criado com sucesso"
    else
      flash.now[:alert] = "Por favor verifique os campos."
      render :new
    end
  end

  def edit
  end

  def update
    if @stock.update(stock_params)
      flash[:success] = "Salvo com sucesso!"
      redirect_to stocks_path
    else
      flash.now[:alert] = "Por favor verifique os campos."
      render :edit
    end
  end

  def destroy
    flash[:success] = "Não é possível remover um estoque."
    redirect_to stocks_path
  end

private

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:name, :user_id)
  end
end
