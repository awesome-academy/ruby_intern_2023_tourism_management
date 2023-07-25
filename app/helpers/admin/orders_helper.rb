module Admin::OrdersHelper
  def load_status
    status_array = Order.statuses.keys.reject{|status| status == Settings.order.status.done}
    status_array.map{|status| [status.titleize, status]}
  end

  def load_search_status
    Order.statuses.keys.map{|status| [status.titleize, status]}
         .unshift([t("admin.orders.status_all"), Settings.all_status_value])
  end

  def select_done_status
    done_status = Settings.order.status.done
    approved_status = Settings.order.status.approved
    status_array = Order.statuses.keys.select{|status| status == done_status || status == approved_status}
    status_array.map{|status| [status.titleize, status]}
  end
end
