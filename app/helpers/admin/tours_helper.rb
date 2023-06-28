module Admin::ToursHelper
  def get_categories
    Category.pluck(:name, :id)
  end
end
