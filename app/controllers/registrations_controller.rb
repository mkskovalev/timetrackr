class RegistrationsController < Devise::RegistrationsController
  before_action :set_user_language, only: [:create]
  before_action :configure_permitted_parameters, if: :devise_controller?

  def create
    if params[:user][:honeypot].present?
      flash[:alert] = 'Bot detected'
      redirect_to new_user_registration_path and return
    end

    super
  end

  protected

  def set_user_language
    user_language = I18n.locale.to_s
    user_language = user_language.in?(I18n.available_locales.map(&:to_s)) ? user_language : I18n.default_locale.to_s
    params[:user][:locale] = user_language
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:locale, :remember_me])
    devise_parameter_sanitizer.permit(:account_update, keys: [:locale])
  end

  def after_sign_up_path_for(resource)
    stored_location_for(resource) || "/#{I18n.locale}/"
  end
end
