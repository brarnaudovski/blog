module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def session_notice(type, message, path = root_path)
    flash[type.to_sym] = message
    redirect_to path and return
  end

  def equal_with_current_user?(other_user)
    current_user == other_user
  end
end
