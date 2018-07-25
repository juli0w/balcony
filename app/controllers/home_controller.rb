class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_caixa!, only: [:caixa, :caixa_update]

  def index
    if current_user.client?
      client = Client.where(section: Section.first, company: current_user.username).first_or_create
      session[:client] = client.id
    end

    if session[:client].blank?
      redirect_to clients_path
    else
      @client = Client.find(session[:client])
      @items = Item.order(:name).search(params[:key].try(:upcase)).first(50)
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
