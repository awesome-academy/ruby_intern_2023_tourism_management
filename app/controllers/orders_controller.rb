class OrdersController < ApplicationController
  load_and_authorize_resource
  rescue_from ActiveRecord::RecordNotFound, with: :order_not_found
  before_action :find_current_tour, :check_order_exist, :check_date_tour, only: %i(new create)
  before_action :build_new_order, only: :new
  before_action :calculate_total_cost, only: :create
  before_action :check_status_pending, only: :update

  def index
    @pagy_user_orders, @orders = pagy current_user.orders.includes(tour: {image_attachment: :blob})
                                                  .includes([:comment]).newest
  end

  def new; end

  def create
    if @order.save
      flash[:success] = t "orders.flash.create_order_success"
      redirect_to user_orders_path current_user
    else
      flash.now[:danger] = t "orders.flash.create_order_failed"
      render :new
    end
  end

  def update
    if @order.update status: Order.statuses[:cancelled]
      flash[:success] = t "orders.flash.cancel_order_success"
      @order.user.send_email_cancelled_order
    else
      flash[:danger] = t "orders.flash.cant_cancelled_tour"
    end
    redirect_to user_orders_path current_user
  end

  private
  def order_params
    params.require(:order).permit :note, :status, :amount_member, :tour_guide, :total_cost,
                                  :contact_name, :contact_phone, :contact_address
  end

  def build_new_order
    @order = current_user.orders.build tour: @current_tour, contact_name: current_user.name,
                                       contact_phone: current_user.phone, contact_address: current_user.address,
                                       amount_member: 1, total_cost: @current_tour.cost
  end

  def calculate_total_cost
    @order = current_user.orders.build order_params
    @order.tour = @current_tour
    @order.total_cost = @order.tour.cost * order_params[:amount_member].to_i
    @order.total_cost += @order.tour_tour_guide_cost if order_params[:tour_guide]
  end

  def find_current_tour
    @current_tour = Tour.find_by id: session[:tour_id]
    return if @current_tour

    flash[:danger] = t "orders.flash.cant_find_current_tour"
    redirect_to root_path
  end

  def check_date_tour
    return if Time.zone.today < @current_tour.start_date

    flash[:danger] = t "orders.flash.tour_ended"
    redirect_to root_path
  end

  def check_status_pending
    return if @order.pending?

    flash[:danger] = t "admin.orders.flash.order_status_changed"
    redirect_to user_orders_path current_user
  end

  def check_order_exist
    return unless current_user.orders&.exists?(tour_id: session[:tour_id])

    flash[:danger] = t "orders.flash.order_existed"
    redirect_to root_path
  end
end
