class Admin::ProductsController < Admin::AdminController
  before_action :load_product, only: %i(edit update destroy)
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

  def edit; end

  def update
    if @product.update(product_params)
      flash[:success] = t "flash.update_product_success"
      redirect_to action: :index
    else
      flash[:error] = t "flash.update_product_fail"
      render :edit
    end
  end

  def destroy
    if @product.destroy
      flash[:success] = t "flash.destroy_product_success"
      redirect_to action: :index
    else
      flash[:danger] = t "flash.destroy_product_fail"
      render :destroy
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :quantity, :status, :author,
                                    :category_id, :publisher, :description,
                                    :image)
  end

  def load_product
    @product = Product.find_by(id: params[:id])
    return if @product

    flash[:error] = t "flash.not_found"
    redirect_to admin_products_path
  end
end
