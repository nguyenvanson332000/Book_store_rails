class SendEmailAdminJob < ApplicationJob
  queue_as :default

  def perform order
    OrderMailer.order_status(order, order.order_details.includes(:product), order.total_money).deliver_now
  end
end
