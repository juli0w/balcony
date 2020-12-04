class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_cart

  def set_cart_variables
    if current_user.client?
      client = Client.where(company: current_user.username).first_or_create(section: Section.last, name: current_user.username)
      session[:client] = client.id
    end

    if session[:client].blank?
      session[:client] = Client.where(company: current_user.username).first_or_create(section: Section.last, name: current_user.username).id
      # redirect_to clients_path
    end

    @sellers = User.where("role >= 1")

    # unless current_user.admin?
    #   @sellers = @sellers.where(default_stock_id: current_user.default_stock_id)
    # end

    @items = Item.where(active: true).order(:name).search(params[:key].try(:upcase)).first(50)
    @promotions = Item.where(active: true).where("virtual_price > 0")
    @client = Client.find(session[:client])
  end

  def reset_session
    session[:order_id] = nil
  end

  def current_cart
    unless session[:order_id].blank?
      begin
        Order.find(session[:order_id])
      rescue
        reset_session
        create_session
      end
    else
      create_session
    end
  end

  def create_session
    order = Order.create
    session[:order_id] = order.id
    order
  end

  def authenticate_admin!
    return true if current_user.admin?

    flash[:alert] = "Você não é administrador"
    sign_out
    redirect_to root_path
  end

  def authenticate_caixa!
    return true if current_user.caixa?

    flash[:alert] = "Você não é caixa"
    sign_out
    redirect_to root_path
  end

  def authenticate_vendedor!
    return true if current_user.vendedor?

    flash[:alert] = "Você não tem permissão"
    sign_out
    redirect_to root_path
  end

protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
