class OrdersController < ApplicationController
  before_action :check_user, only: %i(new create)
  before_action :find_current_tour, only: %i(new create)
  before_action :build_new_order, only: :new

  def new; end

  def create; end

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

  def check_user
    return if logged_in?

    flash[:danger] = t "orders.flash.not_logged_in"
    redirect_to root_path
  end

  def find_current_tour
    @current_tour = Tour.find_by id: session[:tour_id]
    return if @current_tour

    flash[:danger] = t "orders.flash.cant_find_current_tour"
    redirect_to root_path
  end
end
