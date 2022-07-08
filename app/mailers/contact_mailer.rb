# models/contact_mailer.rb:
# Sends contact form mails.
#
# Copyright (c) 2008 UK Citizens Online Democracy. All rights reserved.
# Email: hello@mysociety.org; WWW: http://www.mysociety.org/

class ContactMailer < ApplicationMailer
  include AlaveteliFeatures::Helpers

  # Send message to administrator
  def to_admin_message(name, email, subject, message, logged_in_user, last_request, last_body)
    @message, @logged_in_user, @last_request, @last_body = message, logged_in_user, last_request, last_body

    reply_to_address = MailHandler.address_from_name_and_email(name, email)
    set_reply_to_headers(nil, 'Reply-To' => reply_to_address)

    # From is an address we control so that strict DMARC senders don't get refused
    mail(:from => MailHandler.address_from_name_and_email(name, blackhole_email),
         :to => contact_for_user(@logged_in_user),
         :subject => subject)
  end

  # Send message to another user
  def user_message(from_user, recipient_user, from_user_url, subject, message)
    @message, @from_user, @recipient_user, @from_user_url = message, from_user, recipient_user, from_user_url

    set_reply_to_headers(nil, 'Reply-To' => from_user.name_and_email)

    # From is an address we control so that strict DMARC senders don't get refused
    mail(:from => MailHandler.address_from_name_and_email(from_user.name, blackhole_email),
         :to => recipient_user.name_and_email,
         :subject => subject)
  end

  # Send message to a user from the administrator
  def from_admin_message(recipient_name, recipient_email, subject, message)
    @message = message
    @recipient_name, @recipient_email = recipient_name, recipient_email

    recipient_user = User.find_by_email(recipient_email)

    mail(:from => contact_for_user(recipient_user),
         :to => MailHandler.address_from_name_and_email(@recipient_name, @recipient_email),
         :bcc => AlaveteliConfiguration::contact_email,
         :subject => subject)
  end
end
