class OutputsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_caixa!

  def index
    @outputs = Output.all.page(params[:page]).order("created_at desc")
  end

  def new
    stock_id = Stock.where(user_id: current_user.id).first.try(:id)
    @output = Output.new(stock_id: stock_id, user_id: current_user.id)
  end

  def create
    @output = Output.new(output_params)

    if @output.save
      redirect_to outputs_path, notice: "Retirada feita com sucesso"
    else
      flash.now[:alert] = "Por favor verifique os campos."
      render :new
    end
  end

  def close_day
    @day = params[:day].blank? ? Date.today : params[:day].to_date
    
    @user_id = params[:user_id].blank? ? current_user.id : params[:user_id]
    @user = User.find(@user_id)
    @stock = Stock.find_by_user_id(@user_id)

    @outputs = Output.where(
      "created_at > ? and created_at < ?",
      @day.beginning_of_day,
      @day.end_of_day)

    @orders = Order.
      paid.
      where(
        "created_at > ? and created_at < ?",
        @day.beginning_of_day,
        @day.end_of_day).
      group_by(&:user)
  end

private

  def output_params
    params.require(:output).permit(:value, :stock_id, :user_id)
  end
end
