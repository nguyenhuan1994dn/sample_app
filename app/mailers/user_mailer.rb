class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("mailers.user_mailer.subject_active")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("mailers.user_mailer.subject_pass_reset")
  end
end
