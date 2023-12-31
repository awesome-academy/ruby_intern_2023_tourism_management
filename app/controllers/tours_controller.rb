require_relative "./services/tour_service"

class ToursController < ApplicationController
  authorize_resource
  before_action :load_categories
  before_action :find_tour_by_id, only: :show

  def index
    @q = TourService.load_paging_tour params[:q]
    @pagy_tours, @tours = pagy @q.result, items: Settings.pagy_items_9
  end

  def show
    session[:tour_id] = @tour.id
  end

  private
  def load_categories
    @categories = Category.pluck(:id, :name)
  end

  def find_tour_by_id
    @tour = TourService.find_tour_by_id params[:id]
    return if @tour

    flash[:danger] = t "tours.not_found"
    redirect_to tours_path
  end
end
