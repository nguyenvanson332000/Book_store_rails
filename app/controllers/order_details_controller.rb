class OrderDetailsController < ApplicationController
  before_action :load_order, only: %i(index)

  def index
    @order_detais = @order.order_details.includes(:product).page(params[:page]).per(Settings.per_page)
  end

  private

  def load_order
    @order = Order.find_by(id: params[:order_id])
    return if @order

    flash[:danger] = t "flash.order_not_found"
    redirect_to root_path
  end
end
