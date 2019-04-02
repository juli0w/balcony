class FormulasController < ApplicationController
  before_action :authenticate_admin!, only: [:index, :import, :reset]

  def index
  end

  def import
    @formula = Formula.new(formula_params)
    @formula.import

    redirect_to :back, notice: "Importação em andamento!"
  end

  def formulas
    @tinta_cores = TintaCor.search(params[:keyword])
  end

  def pigmentos
    @tinta_pigmentos = TintaPigmento.all
  end

  def acabamentos
    @tinta_acabamentos = TintaAcabamento.all
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
