class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def dashboard
    if params[:date].blank?
      date = Time.zone.now
    else
      date = params[:date].to_date
    end

    @days = ((date-30.days).to_date..date.to_date).to_a
    # @values = Order.paid.where("created_at >= ? and created_at <= ?", date-30.days, date).
    # group_by(&:created_at)

    @orders = Order.paid.where("created_at > ? and created_at < ?", date.beginning_of_day, date.end_of_day).group_by(&:user)
    @orders_total = Order.paid.where("created_at > ? and created_at < ?",date.beginning_of_day, date.end_of_day).sum(&:total)
    @orders_last_month = Order.paid.where("created_at >= ? and created_at <= ?", (date - 1.month).beginning_of_day, (date - 1.month).end_of_day).sum{|o| o.total || 0 }

    @orders_by_month = Order.paid.where("created_at > ? and created_at < ?", date.at_beginning_of_month, date.at_end_of_month).group_by(&:user)
    @orders_by_month_total = Order.paid.where("created_at >= ? and created_at <= ?", date.at_beginning_of_month, date.at_end_of_month).sum(&:total)
    @orders_by_last_month = Order.paid.where("created_at >= ? and created_at <= ?", (date - 1.month).at_beginning_of_month, (date - 1.month).at_end_of_month).sum{|o| o.total || 0 }

    @orders_seller_by_today = Order.paid.where("created_at > ? and created_at < ?", date.beginning_of_day, date.end_of_day).group_by(&:seller)
    @orders_seller_by_month = Order.paid.where("created_at >= ? and created_at <= ?", date.at_beginning_of_month, date.at_end_of_month).group_by(&:seller)
    @orders_client_by_today = Order.paid.where("created_at > ? and created_at < ?", date.beginning_of_day, date.end_of_day).order("total desc").first(20).group_by(&:client)
    @orders_client_by_month = Order.paid.where("created_at >= ? and created_at <= ?", date.at_beginning_of_month, date.at_end_of_month).order("total desc").first(20).group_by(&:client)

    @data = {
      labels: @days.map{|v| l(v.to_date)},# @values.keys.map{|v| l(v.to_date)},
      datasets: [
        {
            label: "Faturamento",
            backgroundColor: "rgba(160,160,160,0.2)",
            borderColor: "rgba(120,120,120,0.6)",
            data: @days.map {|d| Order.paid.where("created_at >= ? and created_at <= ?", d.beginning_of_day, d.end_of_day).sum(&:total) }# @values.values.map{|o| o.sum(&:total) }
        }
      ]
    }

    @orders_by_month.each do |user, orders|
      @data[:datasets] << {
          label: (user.try(:name) || user.try(:email)),
          backgroundColor: "rgba(220,220,220,0.2)",
          borderColor: "rgba(220,220,220,1)",
          data: @days.map {|d| Order.paid.where("created_at >= ? and created_at <= ? and user_id = ?", d.beginning_of_day, d.end_of_day, user.id).sum(&:total) }# @values.values.map{|o| o.sum(&:total) }
      }
    end
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
