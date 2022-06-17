class SendEmailJob < ApplicationJob
  queue_as :default

  def perform order
    OrderMailer.new_orders(order, order.order_details.includes(:product),
                           order.total_money).deliver_now
  end
end
