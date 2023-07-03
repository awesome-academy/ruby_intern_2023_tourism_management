class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper
  before_action :set_locale

  protect_from_forgery with: :exception
  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def find_order_by_id
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:danger] = t "orders.flash.cant_find_order"
    redirect_to current_user.admin? ? admin_orders_path : (user_orders_path current_user)
  end

  def check_status_pending
    return if @order.pending?

    flash[:danger] = t "admin.orders.flash.order_status_changed"
    redirect_to current_user.admin? ? admin_orders_path : (user_orders_path current_user)
  end
end
