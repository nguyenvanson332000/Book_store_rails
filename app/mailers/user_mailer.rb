class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email, subject: t("flash.account_activation")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("flash.pass_reset")
  end
end
