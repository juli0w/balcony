class EfatorController < ApplicationController
  def index
  end

  def import
    @efator = Efator.new(efator_params)
    @efator.import

    redirect_to root_path, notice: "Importação em andamento!"
  end

private

  def efator_params
    { family: params[:family],
      group: params[:group],
      subgroup: params[:subgroup],
      item: params[:item] }
  end
end
