module OrdersHelper
  def load_service_option
    default_option = Option.new(id: nil, option_name: t("orders.helper.default_option"))
    @order.tour_options.to_a.unshift(default_option)
  end
end
