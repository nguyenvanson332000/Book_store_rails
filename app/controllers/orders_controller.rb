require "paypal-checkout-sdk"

class OrdersController < ApplicationController
  before_action :logged_in_user, only: %i(new create update_order_status)
  before_action :load_order, only: %i(update_order_status)
  before_action :check_status?, only: %i(update_order_status)
  before_action :paypal_init, only: %i(create_order capture_order)
  skip_before_action :verify_authenticity_token

  def index
    @search1 = current_user.orders.ransack(params[:q])
    @orders = @search1.result(distinct: true).sort_by_created.page(params[:page]).per(Settings.per_page)
  end

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
      create_notification
      send_mail_new_order
      flash[:success] = t "order.order_success"
      session[:cart] = nil
      redirect_to root_path
    end
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def update_order_status
    ActiveRecord::Base.transaction do
      @order.update!(status: params[:status])
      @order.cancel_order_quantity if params[:status].eql?("cancel")
      @order.recovery_quantity if params[:status].eql?("pending")
      create_notification
      flash[:info] = t "flash.update_order_succ"
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = t "flash.update_order_fail"
    ensure
      redirect_to orders_path
    end
  end

  def create_order
    request = PayPalCheckoutSdk::Orders::OrdersCaptureRequest::new(params[:order_id])
    begin
      response = @client.execute request
      @order = Order.new
      @order.total_money = params[:total_money]
      @order.status = "approve"
      @order.address = params[:address]
      @order.phone_number = params[:phone_number]
      @order.name_customer = params[:name_customer]
      @order.user_id = current_user.id
      @order.token = response.result.id
      @cart_items = get_line_items_in_cart
      create_order_details
      @order.save!
      @order.paid = response.result.status == "COMPLETED"
      if @order.save
        send_mail_new_order
        session[:cart] = nil
        return render :json => { :status => "COMPLETED", url: orders_path }, :status => :ok
      end
    rescue PayPalHttp::HttpError => ioe
      # HANDLE THE ERROR
    end
  end

  def capture_order
    request = PayPalCheckoutSdk::Orders::OrdersCaptureRequest::new(params[:order_id])
    begin
      response = @client.execute request
      # order = Order.find_by :token => params[:order_id]
      @order = Order.find_by :id => params[:id]
      @order.update!(status: "approve")
      @order.paid = response.result.status == "COMPLETED"
      if @order.save
        send_mail_new_order
        return render :json => { :status => "COMPLETED", url: orders_path }, :status => :ok
      end
    rescue PayPalHttp::HttpError => ioe
      # HANDLE THE ERROR
    end
  end

  private

  def order_params
    params.require(:order).permit(:name_customer, :phone_number, :address,
                                  :total_money)
  end

  def paypal_init
    client_id = "AR_wMHL1LUvDmmBWjb3AjCtLpNk9xxNAeRa4gh7nA8i-BulZ05ezKBzjJDF2fVDvMe7QboM5voPeL4-b"
    client_secret = "EOCCsLMEEzrDoIctvjmApN-BeIfikdgw2OSOClayd5ekFx_o7SoiXXp-HBpOaLDzReEHCY877WJstv9b"
    environment = PayPal::SandboxEnvironment.new client_id, client_secret
    @client = PayPal::PayPalHttpClient.new environment
  end

  def create_order_details
    @cart_items.each do |item|
      check_enough_quantity(item)
      line_item = { product_id: item[:product].id, quantity: item[:quantity] }
      @order.order_details.build(line_item)
    end
  end

  def check_enough_quantity(item)
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

  def load_order
    @order = Order.find_by(id: params[:id])
    return if @order.present?

    flash[:danger] = t "flash.order_not_found"
    redirect_to orders_path
  end

  def check_status?
    return if Order.statuses.keys.include?(params[:status])

    flash[:danger] = t "flash.invalid_status"
    redirect_to orders_path
  end

  def send_mail_new_order
    OrderMailer.new_orders(@order, @order.order_details.includes(:product),
                           @order.total_money).deliver_now
  end

  def create_notification
    Notification.create(recipient: User.first, actor: current_user,
      title: current_user.name + t("notification.title_ad"),
      content: t("notification.content_ad"))
  end
end
