class ApplicationController < ActionController::Base
  USER_ATTRIBUTES = %w(name email id_card phone_number address password
                       current_password).freeze
  before_action :set_locale, :set_search, :load_resources
  protect_from_forgery with: :exception
  include SessionsHelper
  include CartsHelper

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit USER_ATTRIBUTES
    end
  end

  rescue_from CanCan::AccessDenied do |_exception|
    if user_signed_in?
      flash[:danger] = t "flash.reject_access"
      redirect_to root_path
    else
      flash[:danger] = t "flash.not_login"
      redirect_to login_path
    end
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    return if @product

    flash[:danger] = t "flash.product_not_found"
    redirect_to root_path
  end

  def load_resources
    @categories = Category.includes(:products).order(:title)
    @publishers = Product.select(:publisher).distinct
    @authors = Product.select(:author).distinct
    return if @categories && @publishers && @authors

    flash[:danger] = t "flash.product_not_found"
    redirect_to root_path
  end

  def set_search
    @search = Product.ransack(params[:q])
  end

  def check_search_book
    return unless params[:q]

    if @search.result.present?
      flash.clear
      @products = @search.result.page(params[:page]).per(Settings.paginate_size)
    else
      flash[:info] = t "flash.not_found"
    end
  end
end
