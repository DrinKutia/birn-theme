# Allowing users to send user-to-user messages
class Users::MessagesController < UserController

  before_action :set_recipient, :check_can_send_messages, :check_logged_in,
                :set_contact, :set_recaptcha_required

  # Send a message to another user
  def contact
    return unless params[:submitted_contact_form]

    if @recaptcha_required && !verify_recaptcha
      flash.now[:error] = _('There was an error with the reCAPTCHA. ' \
                            'Please try again.')
    else
      if @contact.valid?
        send_message(@user, @recipient_user)
        flash[:notice] = _('Your message to {{recipient_user_name}} has ' \
                           'been sent!',
                           recipient_user_name: @recipient_user.name.html_safe)
        redirect_to user_url(@recipient_user)
      end
    end
  end

  private

  def set_recipient
    @recipient_user = User.find_by!(url_name: params[:url_name])
  end

  def check_can_send_messages
    # Banned from messaging users?
    return unless authenticated? && !authenticated_user.can_contact_other_users?

    @details = authenticated_user.can_fail_html
    render template: 'user/banned'
  end

  def check_logged_in
    # You *must* be logged into send a message to another user. (This is
    # partly to avoid spam, and partly to have some equanimity of openess
    # between the two users)
    #
    # "authenticated?" has done the redirect to signin page for us
    return unless authenticated? || ask_to_login(
      web: _('To send a message to {{user_name}}',
             user_name: CGI.escapeHTML(@recipient_user.name)),
      email: _('Then you can send a message to {{user_name}}.',
               user_name: @recipient_user.name),
      email_subject: _('Send a message to {{user_name}}',
                       user_name: @recipient_user.name)
    )
  end

  def set_contact
    if params[:submitted_contact_form]
      params[:contact][:name] = @user.name
      params[:contact][:email] = @user.email
      @contact = ContactValidator.new(params[:contact])
    else
      @contact = ContactValidator.new(
        message: '' + @recipient_user.name +
                 _(",\n\n\n\nYours,\n\n{{user_name}}", user_name: @user.name)
      )
    end
  end

  def set_recaptcha_required
    @recaptcha_required = AlaveteliConfiguration.user_contact_form_recaptcha
  end

  def send_message(sender, recipient)
    ContactMailer.user_message(
      sender,
      recipient,
      user_url(sender),
      params[:contact][:subject],
      params[:contact][:message]
    ).deliver_now
  end

end
