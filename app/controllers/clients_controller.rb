class ClientsController < ApplicationController
  before_filter :set_client, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def index
    @clients = Client.search(params[:keyword])
  end

  def show
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to clients_path, notice: "Cliente criado com sucesso"
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
      redirect_to clients_path
    else
      flash.now[:alert] = "Por favor verifique os campos."
      render :edit
    end
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
    params.require(:client).permit(:email, :name, :address, :city, :uf, :cpf, :birthday, :phone, :cep)
  end
end
