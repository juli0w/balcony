class ItemsController < ApplicationController
  before_filter :set_item, only: [:edit, :update, :change_location]
  before_action :authenticate_user!
  before_action :authenticate_vendedor!

  def index
    if params[:keyword].present?
      @items = Item.search(params[:keyword])
    else
      @items = Item.all
    end

    unless params[:stock_id].blank?
      @stock = Stock.find(params[:stock_id])

      item_ids = StockItem.where(stock_id: @stock.id).where("quantity <= 0").map(&:item_id)
      
      @items = @items.where(:id => item_ids)
    end

    if params[:noimage]
      @items = @items.where(image: nil)
    end

    @items = @items.page(params[:page]).order(:name)
  end

  def nfe
  end

  def import_nfe
    @nfe = params[:nfe]

    Nfe.import!(@nfe)

    redirect_to items_path, notice: "Nota importada!"
  end

  def change_location
    sl = StockLocation.where(item_id: @item.id, stock_id: params[:stock_id]).first_or_create
    sl.update(location: params[:location])

    redirect_to "#{edit_item_path(@item)}#st-#{params[:stock_id]}"
  end

  def check
    checked = params[:checked]
    stock_id = params[:stock_id]

    StockCount.where(stock_id: stock_id, item_id: params[:id]).
      first_or_create.
      update(checked: checked)
  end

  def print
    if params[:keyword].present?
      @items = Item.search(params[:keyword])
    else
      @items = Item.all.page(params[:page]).per(250)
    end

    render layout: nil
  end

  def edit
  end

  def update
    if @item.update(item_params)
      flash[:success] = "Salvo com sucesso!"
      redirect_to items_path
    else
      flash.now[:alert] = "Por favor verifique os campos."
      render :edit
    end
  end

private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:image, :virtual_price, :remove_image)
  end
end
