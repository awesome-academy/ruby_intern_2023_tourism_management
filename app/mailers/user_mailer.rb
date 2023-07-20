class UserMailer < ApplicationMailer
  def order_approved email
    @email = email
    mail to: email, subject: t("user_mailer.order_approved.subject")
  end

  def order_cancelled email
    @email = email
    mail to: email, subject: t("user_mailer.order_cancelled.subject")
  end
end
