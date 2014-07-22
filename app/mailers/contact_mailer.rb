class ContactMailer < ActionMailer::Base

  def contact_email(contact)
    @contact = contact
    mail(to: ENV["OWNER_EMAIL"], from: @contact.email, :subject => "Contatto Paperclip")
  end
end
