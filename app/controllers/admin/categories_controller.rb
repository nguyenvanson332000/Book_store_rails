class Admin::CategoriesController < Admin::AdminController
  before_action :load_category, only: %i(edit update destroy)

  def index
    @search = Category.ransack(params[:q])
    @categories = @search.result(distinct: true).sort_by_created.page(params[:page]).per(Settings.paginate_size)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = t "flash.create_category_success"
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      flash[:success] = t "flash.update_category_success"
      redirect_to action: :index
    else
      flash[:error] = t "flash.update_category_fail"
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t "flash.destroy_category_success"
      redirect_to action: :index
    else
      flash[:danger] = t "flash.destroy_category_fail"
      render :destroy
    end
  end

  private

  def category_params
    params.require(:category).permit(:content, :title, :parent_id)
  end

  def load_category
    @category = Category.find_by id: params[:id]
    return if @category

    flash[:danger] = t "flash.not_found"
    redirect_to admin_categories_path
  end
end
