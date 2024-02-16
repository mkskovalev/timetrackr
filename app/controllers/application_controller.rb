class ApplicationController < ActionController::Base
  helper_method :admin?
  layout :choose_layout
  add_flash_types :danger, :info, :warning, :success, :messages

  before_action :apply_timezone, 
                :set_locale

  def set_timezone
    session[:timezone] = params[:timezone]
    head :ok
  end

  private

  def choose_layout
    user_signed_in? ? 'application' : 'public'
  end

  def apply_timezone
    if current_user&.timezone.present?
      Time.zone = current_user.timezone
    elsif session[:timezone].present?
      Time.zone = session[:timezone]
    end
  end

  def set_locale
    I18n.locale = user_signed_in? ? current_user_locale : (params[:locale] || cookies[:language] || I18n.default_locale)
  end

  def current_user_locale
    current_user&.locale if current_user&.locale.present?
  end

  def admin?
    current_user&.admin?
  end

  def require_admin
    unless admin?
      flash[:danger] = I18n.t(:access_denied)
      redirect_to root_path
    end
  end
end
