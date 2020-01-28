class CloseDaysController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_caixa!

  def new
    @stocks = Stock.all

    @day = params[:day].blank? ? Date.today : params[:day].to_date
    
    unless current_user.admin?
      @stock_id = current_user.default_stock_id || Stock.first
    else
      @stock_id = params[:stock_id].blank? ? current_user.default_stock_id : params[:stock_id]
    end

    @stock = Stock.find @stock_id

    @close_day = CloseDay.where(day: @day, stock_id: @stock_id).first_or_create
  end

  def update
    @stocks = Stock.all

    @close_day = CloseDay.find_by_id(params[:id])

    if @close_day.update(close_day_params)
      flash[:success] = "Salvo com sucesso!"
      redirect_to new_close_day_path(day: @close_day.day, stock_id: @close_day.stock_id)
    else
      flash.now[:alert] = "Por favor verifique os campos."
      render :new
    end
  end

private

  def close_day_params
    params.require(:close_day).permit(:stock_id, :day, :initial, :final)
  end
end
