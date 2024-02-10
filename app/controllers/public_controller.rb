class PublicController < ApplicationController
  before_action :redirect_to_default_locale

  def index
    if current_user
      redirect_to tracker_path
    end
  end

  private

  def redirect_to_default_locale
    redirect_to "/en#{request.path}" unless params[:locale]
  end
end