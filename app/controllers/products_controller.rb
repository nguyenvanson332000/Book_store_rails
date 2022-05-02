class ProductsController < ApplicationController
  def index
    @products = Product.ordered_by_price
                       .page(params[:page]).per(Settings.paginate_size)
  end
end
