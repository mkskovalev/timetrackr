class TimelinesController < ApplicationController
  before_action :authenticate_user!
  
  def update
    @categories_for_timeline = current_user.categories_for_timeline

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to tracker_path }
    end
  end
end