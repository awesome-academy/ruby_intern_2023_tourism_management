class Admin::OrdersController < Admin::AdminController
  load_and_authorize_resource
  rescue_from ActiveRecord::RecordNotFound, with: :order_not_found
  before_action :allow_status_pending_or_approved, :check_date_before_done, only: :update

  def index
    @pagy_orders, @orders = pagy Order.includes(tour: {image_attachment: :blob})
                                      .filter_by_text(params[:search_text])
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
    @order.user.send_email_approved_order if params[:status] == Settings.order.status.approved
    @order.user.send_email_cancelled_order if params[:status] == Settings.order.status.cancelled
  end

  def allow_status_pending_or_approved
    return if @order.pending? || @order.approved?

    flash[:danger] = t "admin.orders.flash.order_status_changed"
    redirect_to admin_orders_path
  end

  def check_date_before_done
    return unless params[:status] == Settings.order.status.done && @order.tour_end_date > Time.zone.today

    flash[:danger] = t "admin.orders.flash.order_not_end"
    redirect_to admin_orders_path
  end
end
