class ToursController < ApplicationController
  load_and_authorize_resource
  before_action :load_categories
  rescue_from ActiveRecord::RecordNotFound, with: :tour_not_found

  def index
    @pagy, @tours = if params[:category_id]
                      pagy Tour.filter_by_category params[:category_id]
                    elsif params[:name]
                      pagy Tour.filter_by_name params[:name]
                    else
                      pagy Tour.all
                    end
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
