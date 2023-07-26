class Admin::ToursController < Admin::AdminController
  authorize_resource
  before_action :prepare_create_tour, only: :create
  before_action :find_tour_by_id, :check_edit_tour, only: %i(show update edit)
  before_action :check_edit_tour, only: %i(update edit)
  before_action :find_category_by_id, only: :update

  def index
    build_tour_filter
    @pagy_tours, @tours = pagy @q.result
  end

  def new
    @tour = Tour.new
    @tour.build_category
  end

  def create
    if @tour.save
      flash[:success] = t "admin.tours.flash.created_tour_success"
      redirect_to admin_tours_path
      add_option_to_tour
    else
      flash.now[:danger] = t "admin.tours.flash.created_tour_failed"
      render :new
    end
  rescue ActiveRecord::RecordNotUnique
    flash.now[:danger] = t "admin.tours.flash.duplicate_option_name"
    render :new
  end

  def edit; end

  def update
    if @tour.update tour_params.merge(category_id: params[:category_id])
      flash[:success] = t "admin.tours.flash.updated_tour_success"
      redirect_to admin_tours_path
      add_option_to_tour
    else
      flash.now[:danger] = t "admin.tours.flash.updated_tour_failed"
      render :edit
    end
  end

  def show
    render json: @tour.to_json(include: :category)
  end

  private
  def tour_params
    params.require(:tour).permit :name, :image, :start_date, :end_date, :visit_location, :tour_guide_cost,
                                 :cost, :description, :start_location, :content, :is_create_category,
                                 category_attributes: [:name, :description],
                                 options_attributes: [:id, :option_content, :option_name, :option_cost, :_destroy]
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

  def check_edit_tour
    return if Time.zone.today < @tour.start_date

    flash[:danger] = t "admin.tours.flash.cant_edit_tour"
    redirect_to admin_tours_path
  end

  def find_category_by_id
    category = Category.find_by id: params[:category_id]
    return if category

    flash[:danger] = t "admin.tours.flash.category_not_found"
    redirect_to admin_tours_path
  end

  def find_tour_by_id
    @tour = Tour.includes(:category, options: [:rich_text_option_content]).find_by(id: params[:id])
    return if @tour

    flash[:danger] = t "admin.tours.flash.tour_not_found"
    redirect_to admin_tours_path
  end

  def add_option_to_tour
    new_tour_option_ids = params.dig(:tour, :option_ids).reject(&:blank?)
    return if new_tour_option_ids.blank?

    tour_options = []
    new_tour_option_ids.each do |option_id|
      tour_options << TourOption.new(option_id: option_id, tour_id: @tour.id)
    end
    TourOption.import tour_options, all_or_none: true
  end
end
