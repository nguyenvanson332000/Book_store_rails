class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "flash.create_account_success"
      redirect_to root_url
    else
      flash[:danger] = t "flash.create_account_fail"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :id_card, :phone_number, :address,
                             :password, :password_confirmation
  end
end
