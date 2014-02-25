class AdminMailer < ActionMailer::Base
  default from: "notification@example.com"
  
  def cash_payment_confirmation_email(admin, user)
    @user = user
    @admin = admin
    @url = '#'
    mail(to: @admin.email, subject: "Payment Submitted by #{@user.full_name}")
  end
end
