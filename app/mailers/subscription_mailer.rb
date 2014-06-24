class SubscriptionMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.subscription_mail.subject
  #
  def confirm_subscription(subscription)
    @subscription = subscription
    mail(to: @subscription.email, from: ENV["OWNER_EMAIL"], :subject => "Paperclip: riepilogo acquisto")
  end
end
