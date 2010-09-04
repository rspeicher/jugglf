class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user_session, :current_user

  protected

  # Never render layouts for an XHR request
  def render(*args)
    args.push(:layout => false) if request.xhr?
    super(*args)
  end

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_admin
    if current_user
      unless @current_user.is_admin?
        flash[:error] = "You do not have permission to access that page. You have been redirected back to the index."
        redirect_to(root_path)
      end
    else
      return require_user
    end
  end

  def require_user
    unless current_user
      store_location
      flash[:error] = "You must be logged in to access that page."
      redirect_to(login_url)
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      redirect_to(root_path)
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
