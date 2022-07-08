class Users::ConfirmationsController < UserController

  def confirm
    post_redirect = PostRedirect.find_by_email_token(params[:email_token])

    if post_redirect.nil? || !post_redirect.email_token_valid?
      render :template => 'user/bad_token'
      return
    end

    case post_redirect.circumstance
    when 'change_password'
      unless session[:user_id] == post_redirect.user_id
        clear_session_credentials
      end

      redirect_to SafeRedirect.new(post_redirect.uri).path
      return

    when 'normal', 'change_email'
      # !User.stay_logged_in_on_redirect?(nil)
      # # => true
      # !User.stay_logged_in_on_redirect?(user)
      # # => true
      # !User.stay_logged_in_on_redirect?(admin)
      # # => false
      if User.stay_logged_in_on_redirect?(@user)
        session[:admin_confirmation] = 1
      else
        @user = confirm_user!(post_redirect.user)
      end

      sign_in(@user)
    end

    session[:user_circumstance] = post_redirect.circumstance
    do_post_redirect post_redirect, @user
  end

  private

  def confirm_user!(user)
    user.confirm!
    user
  end

end
