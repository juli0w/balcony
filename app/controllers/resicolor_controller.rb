class ResicolorController < ApplicationController
  before_action :authenticate_admin!

  def index
  end

  def import
    @resicolor = Resicolor.new(params[:file], params[:formula])
    @resicolor.import

    redirect_to resicolor_rformulas_path, notice: "OK!"
  end

  def rproducts
    @rproducts = Rproduct.all.page(params[:page]).per(20)
    @items = Item.last(10)
  end

  def search
    @rproduct = Rproduct.find(params[:id])
    @items = Item.order(:name).search(params[:key].try(:upcase)).first(10)

    respond_to do |format|
      format.js { }
    end
  end

  def change
    @rproduct = Rproduct.find(params[:id])
    @rproduct.item_id = params[:item_id]
    @rproduct.save

    respond_to do |format|
      format.js { }
    end
  end

  def rbases
    @rbases = Rbase.all
  end

  def rbase_update
    @rbases = Rbase.all
    @rbase = Rbase.find(rbase_params[:id])
    @rbase.update(rbase_params)

    respond_to do |format|
      format.js { }
    end
  end

  def rformulas
    @rformulas = Rformula.search(params[:keyword])
  end

  def integrate
    @integrate = Rintegration.all
  end

  def reset
    Resicolor.reset!

    redirect_to resicolor_path, notice: "Resetado!"
  end

  private

  def rbase_params
    params.require(:rbase).permit(:id, :price)
  end
end
