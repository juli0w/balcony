class FormulasController < ApplicationController
  before_action :authenticate_admin!, only: [:index, :import, :reset]

  def index
  end

  def import
    @formula = Formula.new(formula_params)
    @formula.import

    redirect_to :back, notice: "Importação em andamento!"
  end

private

  def formula_params
    { tinta_pigmento: params[:tinta_pigmento],
      tinta_embalagem: params[:tinta_embalagem],
      tinta_base: params[:tinta_base],
      tinta_acabamento: params[:tinta_acabamento],
      tinta_produto: params[:tinta_produto],
      tinta_cor: params[:tinta_cor] }
  end
end
