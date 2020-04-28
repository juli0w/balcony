class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:pontos]
  before_action :authenticate_caixa!, only: [:caixa, :caixa_update]

  def index
    # mail = OrderMailer.new_order
    # mail.deliver_now

    if current_user.client?
      client = Client.where(company: current_user.username).first_or_create(section: Section.last, name: current_user.username)
      session[:client] = client.id
    end

    if session[:client].blank?
      session[:client] = Client.where(company: current_user.username).first_or_create(section: Section.last, name: current_user.username).id
      # redirect_to clients_path
    end

    @sellers = User.where("role >= 1")

    unless current_user.admin?
      @sellers = @sellers.where(default_stock_id: current_user.default_stock_id)
    end

    @items = Item.where(active: true).order(:name).search(params[:key].try(:upcase)).first(50)
    @promotions = Item.where(active: true).where("virtual_price > 0")
    @client = Client.find(session[:client])
  end

  def pontos
    @initial_date = "02/01/2019"
    if params[:cpf]
      @client = Client.all.select {|c| c.cpf.try(:gsub, ".", "").try(:gsub, "-", "") == params[:cpf] }.first
      render "view_points", layout: "pontos"
      return
    end

    render layout: "pontos"
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

    @tinta_embalagem = TintaEmbalagem.find_by_id(params[:tinta_embalagem_id])
    # @tinta_acabamento = TintaAcabamento.where(tinta_acabamento_id: params[:tinta_acabamento_id].to_i).first if !params[:acabamento].blank?
    @client = Client.find(session[:client])
    @tintas = TintaCor.joins(:tinta_base).
                       joins(:tinta_acabamento).
                       where("tinta_cors.codigo LIKE :color OR tinta_cors.descricao LIKE :color", color: "%#{params[:color]}%").
                       where("fabricante_id" => params[:fabricante_id])

    @tintas = @tintas.where("tinta_acabamentos.descricao LIKE ?", "%#{params[:acabamento]}%") if !params[:acabamento].blank?
    @tintas = @tintas.where("tinta_acabamentos.tinta_produto_id" => params[:tinta_produto_id].to_i) if !params[:tinta_produto_id].blank?

    @tintas = @tintas.limit(40)

    @tintas = @tintas.reject {|t| t.base(@tinta_embalagem).nil? }
    @tintas = @tintas.reject {|t| t.price_pigmentos(@tinta_embalagem) <= 0 }

    # @tintas = @tintas.reject { |t| (Rproduct.where(code: t.rproduct.code, base: t.base, can: params[:can]).count <= 0) }.first(30)
    # @tintas = @tintas.reject { |t| (t.calculate_price(params[:can]) <= 0) }
    # @tintas = @tintas.reject { |t| (t.price_base(params[:can]) <= 0) }

    # render text: TintaCor.joins(:tinta_base).where("codigo LIKE ?", "%#{params[:color]}%").to_json
    # return
  end

  # def tintas
  #   if current_user.client?
  #     client = Client.where(company: current_user.username).first_or_create(section: Section.last, name: current_user.username)
  #     session[:client] = client.id
  #   end
  #
  #   if session[:client].blank?
  #     session[:client] = Client.where(company: current_user.username).first_or_create(section: Section.last, name: current_user.username).id
  #     # redirect_to clients_path
  #   end
  #
  #   @client = Client.find(session[:client])
  #   if params[:marca] == "Resicolor" and !params[:color].blank?
  #     @tintas = Rformula.joins(:rcolor).
  #                        joins(:rproduct).
  #                        where("rcolors.name LIKE ?", "%#{params[:color]}%")
  #                       #  where("rproducts.can" => params[:can])
  #
  #     @tintas = @tintas.where(rline_id: params[:line].to_i) if !params[:line].blank?
  #     @tintas = @tintas.where("rproducts.code" => params[:rp]) if !params[:rp].blank?
  #
  #     @tintas = @tintas.reject { |t| (Rproduct.where(code: t.rproduct.code, base: t.base, can: params[:can]).count <= 0) }.first(30)
  #     @tintas = @tintas.reject { |t| (t.calculate_price(params[:can]) <= 0) }
  #     @tintas = @tintas.reject { |t| (t.price_base(params[:can]) <= 0) }
  #   end
  # end

  def caixa
    @orders = Order.not_empty.opened
  end

  def caixa_update
    @orders = Order.not_empty.opened
    render partial: "caixa"
  end
end
