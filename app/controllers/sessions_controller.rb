class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      check_activated user
    else
      flash.now[:danger] = t "flash.email_password_combination"
      redirect_to root_url
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def check_remember(user)
    param = params[:session]
    param[:remember_me] == "1" ? remember(user) : forget(user)
  end

  def check_activated(user)
    if user.activated
      log_in user
      redirect_back_or user
    else
      flash[:warning] = t "flash.check_activated"
      edirect_to root_url
    end
  end
end
