class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :set_locale

  protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied, with: :access_denied
  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def order_not_found
    flash[:danger] = t "orders.flash.cant_find_order"
    redirect_to current_user.admin? ? admin_orders_path : (user_orders_path current_user)
  end

  def access_denied
    flash[:danger] = t "application.not_permit_action"
    return redirect_to(root_path) unless current_user&.admin?

    back_path = send "admin_#{controller_name}_path"
    redirect_to back_path
  end

  protected

  def after_sign_in_path_for resource
    if resource.is_a?(User) && resource.admin?
      admin_tours_path
    else
      root_path
    end
  end
end
