class ApplicationController < ActionController::Base
  before_action :set_locale
  protect_from_forgery with: :exception
  include SessionsHelper
  include CartsHelper

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
end
