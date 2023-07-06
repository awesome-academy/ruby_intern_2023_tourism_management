module Admin::OrdersHelper
  def load_status
    Order.statuses.keys.map{|status| [status.titleize, status]}
  end

  def load_search_status
    load_status.unshift([t("admin.orders.status_all"), Settings.all_status_value])
  end
end
