class Admin::OrdersController < Admin::AdminController
  before_action :load_order, :load_detail_total, except: %i(index)

  def index
    @search = Order.ransack(params[:q])
    @orders = @search.result(distinct: true).ordered_by_price.page(params[:page]).per(Settings.paginate_size)
  end

  def show
    @total = total_money @order
  end

  def approve
    ActiveRecord::Base.transaction do
      @order.approve!
      create_notification @order
      send_mail_change_status
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "flash.update_order_fail"
  else
    flash[:success] = t "flash.update_order_succ"
  ensure
    redirect_to admin_orders_path
  end

  def reject
    ActiveRecord::Base.transaction do
      update_quantity_reject @order if @order.pending? || @order.approve?
      @order.pending? ? @order.not_accept! : @order.cancel!
      create_notification @order
      send_mail_change_status
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "flash.update_order_fail"
  else
    flash[:success] = t "flash.update_order_succ"
  ensure
    redirect_to admin_orders_path
  end

  private

  def load_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:warning] = t("flash.not_found", id: params[:id])
    redirect_to admin_orders_path
  end

  def total_money(order)
    order.order_details.includes(:product).reduce(0) do |sum, detail|
      sum + detail.quantity * detail.product_price
    end
  end

  def load_detail_total
    @order_detail = @order.order_details.includes(:product)
    @total = total_money @order
  end

  def update_quantity_reject(_order)
    @order.order_details.each do |detail|
      product = detail.product
      product.quantity += detail.quantity
      product.save!
    end
  end

  def send_mail_change_status
    SendEmailAdminJob.set(wait: 1.minute).perform_later @order
  end

  def create_notification order
    order_content=""
    case order.status
    when "pending"
      order_content = t "notification.order_pending"
    when "approve"
      order_content = t "notification.order_approve"
    when "not_accept"
      order_content = t "notification.order_not_accept"
    when "cancel"
      order_content = t "notification.order_cancel"
    end
    Notification.create(recipient: order.user, actor: current_user,
                          title: t("notification.title"),
                          content: t("notification.content") + order_content)
  end
end
