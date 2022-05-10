class Admin::AdminController < ApplicationController
  before_action :check_admin

  private

  def check_admin
    return if current_user.try :admin?

    flash[:danger] = t "flash.reject_access"
    redirect_to root_url
  end
end
