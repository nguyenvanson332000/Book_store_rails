class Admin::ProductsController < ApplicationController
  def index
    @products = Product.ordered_by_price.page(params[:page]).per(Settings.paginate_size)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = t "flash.create_product_success"
      redirect_to action: :index
    else
      render :new
    end
  end

  private
  def product_params
    params.require(:product).permit(:name, :price, :quantity, :status, :author,
                                    :category_id, :publisher, :description,
                                    :image)
  end
end
