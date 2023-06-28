class Admin::ToursController < Admin::AdminController
  before_action :prepare_create_tour, only: :create
  before_action :find_tour_by_id, only: %i(update edit)

  def index
    @pagy_tours, @tours = pagy Tour.newest
  end

  def new
    @tour = Tour.new
  end

  def create
    if @tour.save
      flash[:success] = t "admin.tours.flash.created_tour_success"
      redirect_to admin_tours_path
    else
      flash[:danger] = t "admin.tours.flash.created_tour_failed"
      render :new
    end
  end

  def edit; end

  def update
    if @tour.update tour_params.merge(category_id: params[:category_id])
      flash[:success] = t "admin.tours.flash.updated_tour_success"
      redirect_to admin_tours_path
    else
      flash[:danger] = t "admin.tours.flash.updated_tour_failed"
      render :edit
    end
  end

  private
  def tour_params
    params.require(:tour).permit :name, :image, :start_date, :end_date, :visit_location,
                                 :cost, :description, :start_location, :content
  end

  def prepare_create_tour
    current_category = Category.find_by id: params[:category_id]
    if current_category
      @tour = current_category.tours.build tour_params
      @tour.image.attach params.dig(:tour, :image)
    else
      flash[:danger] = t "admin.tours.flash.category_not_found"
      redirect_to admin_tours_path
    end
  end

  def find_tour_by_id
    @tour = Tour.find_by id: params[:id]
    return if @tour

    flash[:warning] = t "admin.tours.flash.tour_not_found"
    redirect_to admin_tours_path
  end
end
