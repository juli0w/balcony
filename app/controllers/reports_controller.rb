class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_vendedor!, only: [:sales, :by_client]

  def dashboard
    @orders = Order.paid.where("created_at > ? and created_at < ?", Time.zone.now.beginning_of_day, Time.zone.now.end_of_day).group_by(&:user)
    @orders_by_month = Order.paid.where("created_at > ? and created_at < ?", Date.today.at_beginning_of_month, Date.today.at_end_of_month).group_by(&:user)
  end

  def sales
    # if current_user.vendedor?
    #   @orders = current_user.orders.paid
    # else
      @orders = Order.paid
    # end

    if params[:from].present? and params[:to].present?
      @orders = @orders.where("created_at >= ? and created_at <= ?", params[:from], params[:to])
    end
  end

  def by_client
    if params[:client]
      @clients = Client.search(params[:client])
      @client = @clients.first
      if @client.present?
        @orders = @client.orders

        if params[:from].present? and params[:to].present?
          @orders = @orders.where("created_at >= ? and created_at <= ?", params[:from], params[:to])
        end
      end
    end
  end

  def by_client_print
    by_client

    render layout: nil
  end
end
