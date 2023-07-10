module Admin::ToursHelper
  def load_categories
    Category.pluck(:name, :id)
  end

  def show_new_category?
    action_name == "new" || action_name == "create"
  end
end
