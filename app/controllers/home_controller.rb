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

  def tintas
    if params[:marca] == "Resicolor" and !params[:color].blank?
      @tintas = Rformula.joins(:rcolor).
                         joins(:rproduct).
                         where("rcolors.name LIKE ?", "%#{params[:color]}%").
                         where("rproducts.can == ?", params[:can])

      @tintas = @tintas.where('rline_id == ?', params[:line]) if !params[:line].blank?
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
