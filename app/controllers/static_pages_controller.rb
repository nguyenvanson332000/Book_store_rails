class StaticPagesController < ApplicationController
  def home
    @products = Product.sort_by_created.page(params[:page]).per(Settings.paginate_size)
  end
end
