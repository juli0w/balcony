class UsersController < ApplicationController
  before_filter :set_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authenticate_admin!, except: [:profile, :update_profile]

  def index
    @users = User.search(params[:keyword])
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
    if user_params[:password].blank? and (current_user.admin? || current_user == @user)
      done = @user.update_without_password(user_params)
    else
      done = @user.update(user_params)
    end

    if done
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

  def client_params
    params.require('/profile').permit(:email, :section_id, :name, :address, :city, :uf, :cpf, :birthday, :phone, :cep, :line, :company, :district)
  end
  def user_params
    params.require(:user).permit(:email, :username, :password, :role, :password_confirmation)
  end
end
