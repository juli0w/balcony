class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_vendedor!

  def sales
    if current_user.vendedor?
      @orders = current_user.orders.paid
    else
      @orders = Order.paid
    end
    
    if params[:from].present? and params[:to].present?
      @orders = @orders.where("created_at >= ? and created_at <= ?", params[:from], params[:to])
    end
  end
end
