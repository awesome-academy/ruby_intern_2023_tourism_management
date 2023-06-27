class ToursController < ApplicationController
  before_action :load_categories
  before_action :load_by_id, only: :show

  def index
    @pagy, @tours = if params[:category_id]
                      pagy Tour.filter_by_category params[:category_id]
                    elsif params[:name]
                      pagy Tour.filter_by_name params[:name]
                    else
                      pagy Tour.all
                    end
  end

  def show; end

  private
  def tour_params
    params.require(:tour).permit :category_id, :name
  end

  def load_categories
    @categories = Category.pluck(:id, :name)
  end

  def load_by_id
    @tour = Tour.find_by id: params[:id]
    return if @tour

    flash[:danger] = t "tours.not_found"
    redirect_to tours_path
  end
end
