class Admin::ToursController < Admin::AdminController
  load_and_authorize_resource
  rescue_from ActiveRecord::RecordNotFound, with: :tour_not_found
  before_action :prepare_create_tour, only: :create
  before_action :check_edit_tour, only: %i(update edit)

  def index
    build_tour_filter
    @pagy_tours, @tours = pagy @q.result.includes(:category)
  end

  def new
    @tour = Tour.new
    @tour.build_category
  end

  def create
    if @tour.save
      flash[:success] = t "admin.tours.flash.created_tour_success"
      redirect_to admin_tours_path
    else
      flash.now[:danger] = t "admin.tours.flash.created_tour_failed"
      render :new
    end
  end

  def edit; end

  def update
    if @tour.update tour_params.merge(category_id: params[:category_id])
      flash[:success] = t "admin.tours.flash.updated_tour_success"
      redirect_to admin_tours_path
    else
      flash.now[:danger] = t "admin.tours.flash.updated_tour_failed"
      render :edit
    end
  end

  private
  def tour_params
    params.require(:tour).permit :name, :image, :start_date, :end_date, :visit_location, :tour_guide_cost,
                                 :cost, :description, :start_location, :content, :is_create_category,
                                 category_attributes: [:name, :description, :duration]
  end

  def prepare_create_tour
    @tour = Tour.new tour_params
    @tour.image.attach(params.dig(:tour, :image))
    return if tour_params[:is_create_category] == "1"

    current_category = Category.find_by id: params[:category_id]
    if current_category
      @tour = current_category.tours.build tour_params
    else
      flash[:danger] = t "admin.tours.flash.category_not_found"
      render :new
    end
  end

  def tour_not_found
    flash[:danger] = t "admin.tours.flash.tour_not_found"
    redirect_to admin_tours_path
  end

  def check_edit_tour
    return if Time.zone.today < @tour.start_date

    flash[:danger] = t "admin.tours.flash.cant_edit_tour"
    redirect_to admin_tours_path
  end
end
