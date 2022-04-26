class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      check_remember user
      redirect_to root_url
    else
      flash.now[:danger] = t "flash.email_password_combination"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  def check_remember user
    param = params[:session]
    param[:remember_me] == "1" ? remember(user) : forget(user)
  end
end
