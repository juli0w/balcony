class FormulasController < ApplicationController
  before_action :authenticate_caixa!, only: [:index, :import, :reset]

  def index
  end

  def pigmentos
    @dyes = Dye.all
    # @tinta_pigmentos = TintaPigmento.all
  end

  def search_dye_item
    @dye = Dye.find(params[:id])
    @items = Item.order(:name).search(params[:key].try(:upcase)).first(10)

    respond_to do |format|
      format.js { }
    end
  end

  def change_dye_item
    @dye = Dye.find(params[:id])
    @dye.item_id = params[:item_id]
    @dye.save

    respond_to do |format|
      format.js { }
    end
  end

  def acabamentos
    @bases = ProductBaseItem.all
  end

  def search_base_item
    @base = ProductBaseItem.find(params[:id])
    @items = Item.order(:name).search(params[:key].try(:upcase)).first(10)

    respond_to do |format|
      format.js { }
    end
  end

  def change_base_item
    @base = ProductBaseItem.find(params[:id])
    @base.item_id = params[:item_id]
    @base.save

    respond_to do |format|
      format.js { }
    end
  end

  def import
    @formula = Formula.new(formula_params)
    @formula.import

    redirect_to :back, notice: "Importação em andamento!"
  end

  def formulas
    @tinta_cores = TintaCor.search(params[:keyword])
  end

  def integracao
    @tinta_acabamento_base_items = TintaAcabamentoBaseItem.all
  end

private

  def formula_params
    { tinta_pigmento: params[:tinta_pigmento],
      tinta_embalagem: params[:tinta_embalagem],
      tinta_base: params[:tinta_base],
      tinta_acabamento: params[:tinta_acabamento],
      tinta_produto: params[:tinta_produto],
      tinta_pigmento_item: params[:tinta_pigmento_item],
      tinta_base_item: params[:tinta_base_item],
      tinta_cor: params[:tinta_cor] }
  end
end
