module Admin::OrdersHelper
  def statuses
    Order.statuses.map{|k, v| [k.humanize.capitalize, v]}
  end
end
