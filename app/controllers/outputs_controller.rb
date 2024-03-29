class OutputsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_caixa!
  before_action :authenticate_admin!, only: [:close_day]

  def index
    @outputs = Output.all

    unless params[:day].blank?
      date = params[:day].to_date
      @outputs = @outputs.where(
        "created_at > ? and created_at < ?", date.beginning_of_day, date.end_of_day)
    end

    unless current_user.admin?
      @outputs = @outputs.where(stock_id: current_user.stock_id)
    end

    @outputs = @outputs.page(params[:page]).order("created_at desc")
  end

  def new
    @users = User.all.reject{|u| u.name.blank?}
    stock_id = current_user.stock_id

    @output = Output.new(stock_id: stock_id, user_id: current_user.id)
  end

  def create
    @output = Output.new(output_params.merge({ user_id: current_user.id }))

    unless current_user.admin?
      @output.stock_id = current_user.stock_id
    end

    if @output.save
      redirect_to outputs_path, notice: "Retirada feita com sucesso"
    else
      flash.now[:alert] = "Por favor verifique os campos."
      render :new
    end
  end

  def close_day
    @day = params[:day].blank? ? Date.today : params[:day].to_date
    
    user = current_user.stock.user

    @user_id = params[:user_id].blank? ? user.id : params[:user_id]
    @user = User.find(@user_id)
    @stock = Stock.find_by_user_id(@user_id)

    @outputs = Output.where(
      "created_at > ? and created_at < ?",
      @day.beginning_of_day,
      @day.end_of_day)
    
    @envelopes = @outputs.where("output_type != 1 and output_type != 2 and output_type != 3 or output_type = 0")
    @despesas = @outputs.where(output_type: 1)
    @injecoes = @outputs.where(output_type: 2)
    @vales = @outputs.where(output_type: 3)
    
    @orders = Order.
    paid.
    where(
      "paid_at > ? and paid_at < ?",
      @day.beginning_of_day,
      @day.end_of_day)

    # @total_internet = @orders.where(digital: true).sum(&:total_discounted)

    @orders = @orders.group_by(&:user)
    end
    
    private
    
    def output_params
      params.require(:output).permit(:description, :output_type, :value, :stock_id, :user_id)
    end
  end
