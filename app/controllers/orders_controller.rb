class OrdersController < ApplicationController
  before_action :check_user, only: %i(new create update index)
  before_action :find_current_tour, :check_date_tour, only: %i(new create)
  before_action :build_new_order, only: :new
  before_action :calculate_total_cost, only: :create
  before_action :find_order_by_id, :check_status_pending, only: :update

  def index
    @pagy_user_orders, @orders = pagy current_user.orders.newest
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

  def check_user
    return if user_signed_in?

    flash[:danger] = t "orders.flash.not_logged_in"
    redirect_to login_path
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
end
