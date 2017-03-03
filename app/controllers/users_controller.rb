class UsersController < ApplicationController
  before_filter :set_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def index
    if params[:keyword].present?
      @users = User.where("email LIKE ?", "%#{params[:keyword]}%")
    else
      @users = User.all
    end
  end

  def become
    sign_in(:user, User.find(params[:id]))
    redirect_to root_url
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path, notice: "Usuário criado com sucesso"
    else
      flash.now[:alert] = "Por favor verifique os campos."
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Salvo com sucesso!"
      redirect_to users_path
    else
      flash.now[:alert] = "Por favor verifique os campos."
      render :edit
    end
  end

  def destroy
    @user.delete

    flash[:success] = "Usuário removido"
    redirect_to users_path
  end

private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :username, :password, :role, :password_confirmation)
  end
end
