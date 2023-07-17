module Admin::ToursHelper
  def load_categories
    Category.pluck(:name, :id)
  end

  def load_search_categories
    load_categories.unshift([t("admin.orders.status_all"), ""])
  end

  def show_new_category?
    action_name == "new" || action_name == "create"
  end

  def load_cost_range_options
    [
      [t("tours.cost_range.0_to_2m_range"), t("tours.cost_range.0_to_2m_value")],
      [t("tours.cost_range.2m_to_4m_range"), t("tours.cost_range.2_to_4m_value")],
      [t("tours.cost_range.over_4m_range"), t("tours.cost_range.over_4m_value")]
    ]
  end
end
