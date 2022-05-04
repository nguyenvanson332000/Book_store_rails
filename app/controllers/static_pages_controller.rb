class StaticPagesController < ApplicationController
  before_action :load_production, only: %i(show)
  def home
    @products = Product.sort_by_created.page(params[:page]).per(Settings.paginate_size)
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
end
