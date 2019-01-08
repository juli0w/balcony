class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_caixa!, only: [:caixa, :caixa_update]

  def index
    if current_user.client?
      client = Client.where(company: current_user.username).first_or_create(section: Section.last, name: current_user.username)
      session[:client] = client.id
    end

    if session[:client].blank?
      session[:client] = Client.where(company: current_user.username).first_or_create(section: Section.last, name: current_user.username).id
      # redirect_to clients_path
    end

    @items = Item.order(:name).search(params[:key].try(:upcase)).first(50)
    @client = Client.find(session[:client])
  end

  # def tintas
  #   if params[:marca] == "Resicolor" and !params[:color].blank?
  #     @tintas = Rproduct.joins(:rformulas).
  #                        where("rformulas.color LIKE ?", "%#{params[:color]}%").
  #                        where(can: params[:can])
  #
  #     @tintas = @tintas.where(rline_id: params[:line].to_i) if !params[:line].blank?
  #
  #     # @tintas = @tintas.reject { |t| (Rproduct.where(code: t.rproduct.code, base: t.base, can: params[:can]).count <= 0) }
  #   end
  # end

  def tintas
    if current_user.client?
      client = Client.where(company: current_user.username).first_or_create(section: Section.last, name: current_user.username)
      session[:client] = client.id
    end

    if session[:client].blank?
      session[:client] = Client.where(company: current_user.username).first_or_create(section: Section.last, name: current_user.username).id
      # redirect_to clients_path
    end

    @client = Client.find(session[:client])
    if params[:marca] == "Resicolor" and !params[:color].blank?
      @tintas = Rformula.joins(:rcolor).
                         joins(:rproduct).
                         where("rcolors.name LIKE ?", "%#{params[:color]}%")
                        #  where("rproducts.can" => params[:can])

      @tintas = @tintas.where(rline_id: params[:line].to_i) if !params[:line].blank?
      @tintas = @tintas.where("rproducts.code" => params[:rp]) if !params[:rp].blank?

      @tintas = @tintas.reject { |t| (Rproduct.where(code: t.rproduct.code, base: t.base, can: params[:can]).count <= 0) }.first(30)
      @tintas = @tintas.reject { |t| (t.calculate_price(params[:can]) <= 0) }.first(30)
    end
  end

  def caixa
    @orders = Order.not_empty.opened
  end

  def caixa_update
    @orders = Order.not_empty.opened
    render partial: "caixa"
  end
end
