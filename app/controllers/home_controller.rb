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

  def caixa
    @orders = Order.not_empty.opened
  end

  def caixa_update
    @orders = Order.not_empty.opened
    render partial: "caixa"
  end
end
