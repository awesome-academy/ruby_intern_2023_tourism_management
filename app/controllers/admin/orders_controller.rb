class Admin::OrdersController < Admin::AdminController
  before_action :find_order_by_id, :check_status_pending, only: :update

  def index
    @pagy_orders, @orders = pagy Order.filter_by_text(params[:search_text])
                                      .filter_by_status(params[:status_search]).newest
  end

  def update
    if @order.update status: Order.statuses[params[:status]]
      flash[:success] = t "admin.orders.flash.update_order_success"
    else
      flash[:danger] = t "admin.orders.flash.cant_update_order"
    end
    redirect_to admin_orders_path
  end
end
