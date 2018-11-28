class EfatorController < ApplicationController
  before_action :authenticate_admin!, only: [:index, :import, :reset]

  def index
  end

  def import
    @efator = Efator.new(efator_params)
    @efator.import

    redirect_to root_path, notice: "Importação em andamento!"
  end

  def reset
    Efator.reset!

    redirect_to import_path, notice: "Resetado!"
  end

private

  def efator_params
    { family: params[:family],
      group: params[:group],
      subgroup: params[:subgroup],
      item: params[:item] }
  end
end
