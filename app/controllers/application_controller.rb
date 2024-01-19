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
    Time.zone = session[:timezone] if session[:timezone].present?
  end
end
