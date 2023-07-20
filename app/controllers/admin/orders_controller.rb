class Admin::OrdersController < Admin::AdminController
  load_and_authorize_resource
  rescue_from ActiveRecord::RecordNotFound, with: :order_not_found
  before_action :check_status_pending, only: :update

  def index
    @pagy_orders, @orders = pagy Order.filter_by_text(params[:search_text])
                                      .filter_by_status(params[:status_search]).newest
  end

  def update
    if @order.update status: Order.statuses[params[:status]]
      flash[:success] = t "admin.orders.flash.update_order_success"
      send_mail_update_order
    else
      flash[:danger] = t "admin.orders.flash.cant_update_order"
    end
    redirect_to admin_orders_path
  end

  private
  def send_mail_update_order
    @order.user.send_email_approved_order if params[:status] == Settings.order_status_approved
    @order.user.send_email_cancelled_order if params[:status] == Settings.order_status_cancelled
  end
end
