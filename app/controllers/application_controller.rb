class ApplicationController < ActionController::Base
  layout :choose_layout

  before_action :apply_timezone

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
end
