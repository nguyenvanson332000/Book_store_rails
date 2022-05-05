class OrdersController < ApplicationController
  before_action :logged_in_user, only: %i(new create)

  def new
    @order = current_user.orders.build
    @cart_items = get_line_items_in_cart
  end

  def create
    ActiveRecord::Base.transaction do
      @order = current_user.orders.build
      @cart_items = get_line_items_in_cart
      create_order_details
      @order.assign_attributes(order_params)
      @order.save!
      flash[:success] = t "order.order_success"
      session[:cart] = nil
      redirect_to root_path
    end
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  private

  def order_params
    params.require(:order).permit(:name_customer, :phone_number, :address,
                                  :total_money)
  end

  def create_order_details
    @cart_items.each do |item|
      check_enough_quantity(item)
      line_item = {product_id: item[:product].id, quantity: item[:quantity]}
      @order.order_details.build(line_item)
    end
  end

  def check_enough_quantity item
    return if item[:product].quantity >= item[:quantity]

    flash.now[:warning] = t("product.please_update_quantity",
                            name: item[:product].name)
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "flash.please_login"
    redirect_to login_url
  end
end
