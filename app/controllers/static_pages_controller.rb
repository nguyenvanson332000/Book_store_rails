class StaticPagesController < ApplicationController
  before_action :load_production, only: %i(show)
  before_action :check_search_book, :load_product_status, only: :home
  before_action :load_categories, :load_publishers, :load_authors,
                only: %i(home filter_by_category filter_by_publisher filter_by_author)

  def home
    @products = @search.result(distinct: true).sort_by_created.page(params[:page]).per(Settings.paginate_size)
  end

  def show
  end

  def filter_by_category
    @products = @search.result(distinct: true).by_category(params[:id]).sort_by_created
                       .page(params[:page]).per(Settings.paginate_size)
    render "static_pages/home"
  end

  def filter_by_publisher
    @products = @search.result(distinct: true).search_publisher(params[:id]).sort_by_created
                       .page(params[:page]).per(Settings.paginate_size)
    render "static_pages/home"
  end

  def filter_by_author
    @products = @search.result(distinct: true).search_author(params[:id]).sort_by_created
      .page(params[:page]).per(Settings.paginate_size)
    render "static_pages/home"
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

  def load_categories
    @categories = Category.includes(:products).order(:title)
    return if @categories

    flash[:danger] = t "flash.product_not_found"
    redirect_to root_path
  end

  def load_publishers
    @publishers = Product.select(:publisher).distinct
    return if @publishers

    flash[:danger] = t "flash.product_not_found"
    redirect_to root_path
  end

  def load_authors
    @authors = Product.select(:author).distinct
    return if @authors

    flash[:danger] = t "flash.product_not_found"
    redirect_to root_path
  end
end
