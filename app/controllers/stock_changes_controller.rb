class StockChangesController < ApplicationController
  before_filter :set_stock_change, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authenticate_caixa!

  def index
    @stock_changes = StockChange.all
  end

  def new
    @item = Item.find(params[:item_id])

    if params[:zerar]
      @stock_id = params[:stock_id]
      @stock = Stock.find(@stock_id)
      quantity = @stock.of_item(@item.id)

      in_out = quantity < 0 ? "in" : "out"

      @stock_change = StockChange.create({
        quantity: quantity.abs,
        item_id: @item.id,
        stock_id: @stock_id,
        state: in_out,
        observation: "AUTO: Reset"
      }).push!

      redirect_to [:edit, @item], notice: "Alteração feita com sucesso"
    else
      @stock_change = StockChange.new(item_id: @item.id)
    end
  end

  def create
    @stock_change = StockChange.new(stock_change_params)

    if @stock_change.save
      @stock_change.push!
      redirect_to [:edit, @stock_change.item], notice: "Alteração feita com sucesso"
    else
      flash.now[:alert] = "Por favor verifique os campos."
      render :new
    end
  end

  def edit
  end

  def update
    if @stock_change.update(stock_change_params)
      flash[:success] = "Salvo com sucesso!"
      redirect_to stock_changes_path
    else
      flash.now[:alert] = "Por favor verifique os campos."
      render :edit
    end
  end

  def destroy
    flash[:success] = "Não é possível remover um estoque."
    redirect_to stock_changes_path
  end

private

  def set_stock_change
    @stock_change = StockChange.find(params[:id])
  end

  def stock_change_params
    params.require(:stock_change).permit(:quantity, :item_id, :stock_id, :state, :observation)
  end
end
