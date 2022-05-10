class Admin::OrdersController < Admin::AdminController
  before_action :load_order, only: %i(show)
  def index
    @orders = Order.ordered_by_price.page(params[:page]).per(Settings.paginate_size)
  end

  def show
    @total = total_money @order
  end

  private
  def load_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:warning] = t("flash.not_found", id: params[:id])
    redirect_to action: :index
  end

  def total_money order
    order.order_details.includes(:product).reduce(0) do |sum, detail|
      sum + detail.quantity * detail.product_price
    end
  end
end
