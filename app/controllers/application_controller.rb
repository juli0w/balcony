class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_cart

  def reset_session
    session[:order_id] = nil
  end

  def current_cart
    unless session[:order_id].blank?
      Order.find(session[:order_id])
    else
      order = Order.create
      session[:order_id] = order.id
      order
    end
  end

  def authenticate_admin!
    return true if current_user.admin?

    flash[:alert] = "Você não é administrador"
    redirect_to root_path
  end

  def authenticate_caixa!
    return true if current_user.caixa?

    flash[:alert] = "Você não é caixa"
    redirect_to root_path
  end

protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
