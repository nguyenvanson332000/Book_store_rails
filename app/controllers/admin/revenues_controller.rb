class Admin::RevenuesController < ApplicationController
  before_action :authenticate_user!
  authorize_resource class: false

  def index; end

  def search_revenue
    date = params[:date].to_date
    @orders_by_date = Order.find_date_accept(date)
    if @orders_by_date.present?
      @total = Order.find_date_accept(date).find_sum_day
    else
      flash[:danger] = "Không có dữ liệu"
      redirect_to admin_revenues_path
    end
  end
end
