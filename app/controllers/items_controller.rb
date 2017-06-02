class ItemsController < ApplicationController
  before_filter :set_item, only: [:edit, :update]
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def index
    if params[:keyword].present?
      @items = Item.search(params[:keyword]).page(params[:page])
    else
      @items = Item.all.page(params[:page])
    end

    if params[:noimage]
      @items = @items.where(image: nil)
    end
  end

  def print
    if params[:keyword].present?
      @items = Item.search(params[:keyword])
    else
      @items = Item.all
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
    params.require(:item).permit(:image, :remove_image)
  end
end
