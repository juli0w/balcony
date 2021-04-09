class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def dashboard
    if params[:date].blank?
      date = Time.zone.now
    else
      date = params[:date].to_date
    end

    if params[:from].blank?
      from = date-1.month
    else
      from = params[:from].to_date
    end

    @days = (from.to_date..date.to_date).to_a
    # @values = Order.paid.where("created_at >= ? and created_at <= ?", date-30.days, date).
    # group_by(&:created_at)

    @orders = Order.paid.where("created_at > ? and created_at < ?", date.beginning_of_day, date.end_of_day).group_by(&:user)
    @orders_total = Order.paid.where("created_at > ? and created_at < ?",date.beginning_of_day, date.end_of_day).sum(&:total)
    @orders_last_month = Order.paid.where("created_at >= ? and created_at <= ?", (from - 1.month).beginning_of_day, (date - 1.month).end_of_day).sum{|o| o.total || 0 }

    @orders_by_month = Order.paid.where("created_at > ? and created_at < ?", from.beginning_of_day, date.end_of_day).group_by(&:user)
    @orders_by_month_total = Order.paid.where("created_at >= ? and created_at <= ?", from.beginning_of_day, date.end_of_day).sum(&:total)
    @orders_by_last_month = Order.paid.where("created_at >= ? and created_at <= ?", (from - 1.month).beginning_of_day, (date - 1.month).end_of_day).sum{|o| o.total || 0 }

    @orders_seller_by_today = Order.paid.not_db.where("created_at > ? and created_at < ?", date.beginning_of_day, date.end_of_day).group_by(&:seller)
    @orders_seller_by_month = Order.paid.not_db.where("created_at >= ? and created_at <= ?", from.beginning_of_day, date.end_of_day).group_by(&:seller)

    @orders_client_by_today = Order.paid.where("created_at > ? and created_at < ?", date.beginning_of_day, date.end_of_day).order("total desc").first(20).group_by(&:client)
    @orders_client_by_month = Order.paid.where("created_at >= ? and created_at <= ?", from.beginning_of_day, date.end_of_day).order("total desc").first(20).group_by(&:client)

    @data = {
      labels: @days.map{|v| l(v.to_date)},# @values.keys.map{|v| l(v.to_date)},
      datasets: [
        {
            label: "Faturamento",
            backgroundColor: "rgba(160,255,160,0.2)",
            borderColor: "rgba(120,255,120,0.6)",
            data: @days.map {|d| Order.paid.where("created_at >= ? and created_at <= ?", d.beginning_of_day, d.end_of_day).sum(&:total) }# @values.values.map{|o| o.sum(&:total) }
        }
      ]
    }

    i = 1

    @orders_by_month.each do |user, orders|
      if user
        color = get_color(i)
        i += 1
        @data[:datasets] << {
            label: (user.try(:name) || user.try(:email)),
            backgroundColor: "rgba(#{color},0.2)",
            borderColor: "rgba(#{color},1)",
            data: @days.map {|d| Order.paid.where("created_at >= ? and created_at <= ? and user_id = ?", d.beginning_of_day, d.end_of_day, user.try(:id)).sum(&:total) }# @values.values.map{|o| o.sum(&:total) }
        }
      end
    end
  end

  def by_year
    if params[:date].blank?
      date = Time.zone.now
    else
      date = params[:date].to_date
    end

    @orders = Order.paid.where("created_at > ? and created_at < ?", (date -11.months).beginning_of_month, date.end_of_month)#.group_by(&:user)

    @months = []
    (-11..0).each do |x|
      @months << (date+x.months).strftime("%m/%Y")
    end
    @data_year = {
      labels: @months,#.map(&:v),#{|v| l(v.to_date)},# @values.keys.map{|v| l(v.to_date)},
      datasets: [
        {
            label: "Faturamento por mês",
            backgroundColor: "rgba(160,255,160,0.2)",
            borderColor: "rgba(120,255,120,0.6)",
            data: @months.map {|d|
                Order.paid.where("created_at >= ? and created_at <= ?",
                    d.to_date.beginning_of_month,
                    d.to_date.end_of_month).sum(&:total) }# @values.values.map{|o| o.sum(&:total) }
        }
      ]
    }

    i = 1

    @orders_by_year = @orders.group_by(&:user)

    @orders_by_year.each do |user, orders|
      if user
        color = get_color(i)
        i += 1
        @data_year[:datasets] << {
            label: (user.try(:name) || user.try(:email)),
            backgroundColor: "rgba(#{color},0.2)",
            borderColor: "rgba(#{color},1)",
            data: @months.map {|d| Order.paid.where("created_at >= ? and created_at <= ? and user_id = ?", d.to_date.beginning_of_month, d.to_date.end_of_month, user.try(:id)).sum(&:total) }# @values.values.map{|o| o.sum(&:total) }
        }
      end
    end
  end

  def get_color index
    { 1 => "120,120,255",
      2 => "255,120,120",
      3 => "120,120,120",
      4 => "255,20,255" }[index]
  end

  def sales_by_day
    @date = params[:date].blank? ? Date.today : params[:date].to_date
    stock_id = params[:stock_id] || current_user.default_stock.id

    @stock = Stock.find(stock_id)
    user_id = @stock.user_id

    @orders = Order.
                paid.
                where("
                    created_at > ? and
                    created_at < ? and
                    user_id = ?",
                  @date.beginning_of_day,
                  @date.end_of_day,
                  user_id)
  end

  def abc
    start = 6.month.ago
    final = Date.today

    @orders = Order.paid.where('created_at >= ? and created_at <= ?', start, final)

    @order_items = @orders.map {|o| o.
                    order_items.
                    joins(:item).
                    where("items.name NOT LIKE ? and items.name NOT LIKE ?", "%R PIGMENTO%", "%SW CORANTE%").
                    pluck(:item_id, :quantity).to_h }
    results = @order_items.inject(Hash.new(0)) { |memo, subhash| subhash.each { |prod, value| memo[prod] += value } ; memo }

    @results = results.sort_by{|k,v| v}.reverse
  end

  def items
    if params[:item].present?
      @date = params[:start].to_date || Date.today

      beginning = @date.beginning_of_month
      ending = Date.today.end_of_month

      @orders = OrderItem.joins(:item).where("
        items.name LIKE ? and
        order_items.created_at > ? and
        order_items.created_at < ?",
          "%#{params[:item]}%",
        beginning,
        ending).collect(&:order).uniq
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

    @orders = @orders.first(50)
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
