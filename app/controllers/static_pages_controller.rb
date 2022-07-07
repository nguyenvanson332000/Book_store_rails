require "net/https"

class StaticPagesController < ApplicationController
  before_action :load_production, only: %i(show)
  before_action :check_search_book, :load_product_status, only: :home
  before_action :load_categories, :load_publishers, :load_authors,
                only: %i(home filter_by_category filter_by_publisher filter_by_author)
  before_action :load_url_api, only: :show_product_ai

  def home
    @products = @search.result(distinct: true).sort_by_created.page(params[:page]).per(Settings.paginate_size_9)
  end

  def show
  end

  def show_product_ai
    if @product_url.present?
      @products = Product.ransack(id_in: @product_url["recommendations"]).result(distinct: true).sort_by_created.page(params[:page]).per(Settings.paginate_size_9)
      render "static_pages/home"
    else
      sql = %{
              SELECT
                p.id, p.name, @buy_count := count(od.quantity) AS buy_count
              FROM products AS p
              INNER JOIN order_details AS od
              ON p.id = od.product_id GROUP BY(od.product_id)
              ORDER BY buy_count DESC
            }
      records_array = ActiveRecord::Base.connection.exec_query(sql)
      @product_ids = []
      # @products = records_array.rows
      records_array.to_a.each do |product|
        @product_ids << product["id"]
      end
      @products = Product.ransack(id_in: @product_ids).result(distinct: true).page(params[:page]).per(Settings.paginate_size_9)
      render "static_pages/home"
    end
  end

  def filter_by_category
    @products = @search.result(distinct: true).by_category(params[:id]).sort_by_created
                       .page(params[:page]).per(Settings.paginate_size_9)
    render "static_pages/home"
  end

  def filter_by_publisher
    @products = @search.result(distinct: true).search_publisher(params[:id]).sort_by_created
                       .page(params[:page]).per(Settings.paginate_size_9)
    render "static_pages/home"
  end

  def filter_by_author
    @products = @search.result(distinct: true).search_author(params[:id]).sort_by_created
      .page(params[:page]).per(Settings.paginate_size_9)
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
    @products_all_hot = Product.where(status: "Hot").sort_by_created.page(params[:page]).per(Settings.paginate_size_9)
    @products_all_new = Product.where(status: "New").sort_by_created.page(params[:page]).per(Settings.paginate_size_9)
    @products_all_trend = Product.where(status: "Trend").sort_by_created.page(params[:page]).per(Settings.paginate_size_9)
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

  def load_url_api
    uri = URI("https://book-recomm.herokuapp.com/recommendations?user_id=" + current_user.id.to_s)
    req = Net::HTTP.get(uri)
    data = JSON.parse(req)
    @product_url = data["data"]
  end
end
