class StaticPagesController < ApplicationController
  before_action :load_production, only: %i(show)
  before_action :check_search_book, :load_product_status, only: :home
  def home
    @products =  @search.result(distinct: true).sort_by_created.page(params[:page]).per(Settings.paginate_size)
  end

  def show
  end

  private

  def load_production
    @products = Product.find_by(id: params[:id])
    return if @products

    flash[:warning] = t "flash.product_not_found"
    redirect_to home_client_path
  end

  def load_product_status
    @products_all_hot = Product.where(status: "Hot").sort_by_created.page(params[:page]).per(Settings.paginate_size)
    @products_all_new = Product.where(status: "New").sort_by_created.page(params[:page]).per(Settings.paginate_size)
    @products_all_trend = Product.where(status: "Trend").sort_by_created.page(params[:page]).per(Settings.paginate_size)
    return if @products_all_hot && @products_all_new && @products_all_trend

    flash[:danger] = t "flash.product_not_found"
    redirect_to root_path
  end
end
