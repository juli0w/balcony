class ClientsController < ApplicationController
  before_filter :set_client, only: [:select, :show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authenticate_vendedor!, except: [:clear, :profile, :update_profile]

  def index
    @clients = Client.search(params[:keyword])

    respond_to do |format|
      format.html { @clients = @clients.page(params[:page]) }
      format.xls
    end
  end

  def show
  end

  def profile
    @user = Client.where(company: current_user.username).first
  end

  def update_profile
    @user = Client.where(company: current_user.username).first
    if @user.update(client_params)
      flash[:success] = "Salvo com sucesso!"
      redirect_to profile_path
    else
      flash.now[:alert] = "Por favor verifique os campos."
      render :profile
    end
  end

  def new
    @client = Client.new

    begin
      code = SecureRandom.hex(3)
    end until Client.find_by_email(code).nil?

    @client.email = code
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to clients_path(keyword: @client.name), notice: "Cliente criado com sucesso"
    else
      flash.now[:alert] = "Por favor verifique os campos."
      render :new
    end
  end

  def edit
  end

  def update
    if @client.update(client_params)
      flash[:success] = "Salvo com sucesso!"
      redirect_to clients_path(keyword: @client.name)
    else
      flash.now[:alert] = "Por favor verifique os campos."
      render :edit
    end
  end

  def select
    session[:client] = @client.id
    redirect_to root_path
  end

  def clear
    session[:client] = nil
    redirect_to root_path
  end

  def destroy
    @client.delete

    flash[:success] = "Cliente removido"
    redirect_to clients_path
  end

private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:email, :section_id, :name, :address, :city, :uf, :cpf, :birthday, :phone, :cep, :line, :company, :district)
  end
end
