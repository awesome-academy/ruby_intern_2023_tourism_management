class ToursController < ApplicationController
  load_and_authorize_resource
  before_action :load_categories
  rescue_from ActiveRecord::RecordNotFound, with: :tour_not_found

  def index
    build_tour_filter
    @pagy_tours, @tours = pagy @q.result.includes(:category), items: Settings.pagy_items_9
  end

  def show
    session[:tour_id] = @tour.id
  end

  private
  def load_categories
    @categories = Category.pluck(:id, :name)
  end

  def tour_not_found
    flash[:danger] = t "tours.not_found"
    redirect_to tours_path
  end
end
