class ApplicationController < ActionController::Base
  layout :choose_layout

  before_action :apply_timezone, 
                :set_locale

  add_flash_types :danger, :info, :warning, :success, :messages

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
end
