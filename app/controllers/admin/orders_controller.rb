class Admin::OrdersController < Admin::AdminController
  before_action :find_order_by_id, only: :update

  def index
    @pagy_orders, @orders = pagy Order.filter_by_text(params[:search_text])
                                      .filter_by_status(params[:status_search]).newest
  end

  def update
    if @order.update status: Order.statuses[params[:status]]
      @pagy_orders, @orders = pagy Order.newest
      respond_to do |format|
        format.html{redirect_to admin_orders_path}
        format.js
      end
    else
      flash[:danger] = t "admin.orders.flash.cant_update_tour"
      redirect_to admin_orders_path
    end
  end

  private
  def find_order_by_id
    @order = Order.find_by id: params[:id]
    return if @order

    flash.now[:danger] = t "admin.orders.flash.order_not_found"
    redirect_to admin_orders_path
  end
end
