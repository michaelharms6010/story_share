module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless logged_in? && current_user.admin
  end

  def logged_in_profile_incomplete
    if !logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    elsif !activated?
      flash[:warning] = "Please check your email to activate your account."
      redirect_to root_url
    end
  end

  def logged_in_user
    if !logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    elsif !activated?
      flash[:warning] = "Please check your email to activate your account."
      redirect_to root_url
    elsif !current_user.profile_completed
      redirect_to profile_edit_url
    end
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  def activated?
    current_user.present? && current_user.activated
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
