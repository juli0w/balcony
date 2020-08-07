class ItemsController < ApplicationController
  before_filter :set_item, only: [:edit, :update]
  before_action :authenticate_user!
  before_action :authenticate_admin!

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

  def become
    sign_in(:item, Item.find(params[:id]))
    redirect_to root_url
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
