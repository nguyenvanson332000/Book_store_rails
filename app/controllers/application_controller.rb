class ApplicationController < ActionController::Base
  USER_ATTRIBUTES = %w(name email id_card phone_number address password
                  current_password).freeze
  before_action :set_locale, :set_search
  protect_from_forgery with: :exception
  include SessionsHelper
  include CartsHelper

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit USER_ATTRIBUTES
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
