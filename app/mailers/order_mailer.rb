class OrderMailer < ApplicationMailer
  def order_status(order, order_detail, total)
    @order = order
    @order_detail = order_detail
    @total = total
    mail to: @order.user_email, subject: t("order_mailer.title")
  end

  def new_orders(order, order_detail, total)
    @order = order
    @order_detail = order_detail
    @total = total
    mail to: @order.user_email, subject: t("order_mailer.title")
  end
end
